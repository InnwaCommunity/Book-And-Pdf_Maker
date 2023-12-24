import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_gallery/config/routes.dart';
import 'package:private_gallery/config/routes_ext.dart';
import 'package:private_gallery/models/edit_photo_model.dart';
import 'package:private_gallery/models/photo_detail_model.dart';
import 'package:private_gallery/module/photo_widget/bloc/photo_widget_page_bloc.dart';
import 'package:private_gallery/module/photodetail/showphotodetail.dart';
import 'package:private_gallery/util/service/function_service.dart';
import 'package:video_player/video_player.dart';

class PhotoWidgetPage extends StatefulWidget {
  final DateTime selectedDate;
  const PhotoWidgetPage({required this.selectedDate, super.key});

  @override
  State<PhotoWidgetPage> createState() => _PhotoWidgetPageState();
}

class _PhotoWidgetPageState extends State<PhotoWidgetPage> {
  DateTime selectedDate = DateTime.now();
  bool isMulti = false;
  List<File> images = [];
  List<File> selectedPhotos = [];
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    retrieveImage(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoWidgetPageBloc, PhotoWidgetPageState>(
      builder: (context, state) {
        if (state is SelectedMultiPhoto) {
            selectedPhotos = state.selectedPhotos;
            isMulti = state.selectedPhotos.isNotEmpty ? state.isMulti : false;
          }
        return Scaffold(
          body: Center(
              child: Column(
            children: [
              Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    '${selectedDate.year.toString()}-${selectedDate.month.toString()}-${selectedDate.day.toString()}',
                    style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500),
                  )),
              images.isNotEmpty
                  ? Expanded(
                      child: GridView.count(
                        childAspectRatio: 1,
                        crossAxisCount: 4,
                        children: images.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                                onLongPress: () {
                                  BlocProvider.of<PhotoWidgetPageBloc>(context)
                                      .add(SelectMultiPhoto(
                                          isMulti: true,
                                          selectedPhoto: e,
                                          selectedPhotos: selectedPhotos));
                                },
                                onTap: () {
                                  if (isMulti) {
                                    BlocProvider.of<PhotoWidgetPageBloc>(
                                            context)
                                        .add(SelectMultiPhoto(
                                            isMulti: true,
                                            selectedPhoto: e,
                                            selectedPhotos: selectedPhotos));
                                  } else {
                                    context.toName(Routes.photoDetail,
                                        arguments: ViewPhotoDetail(
                                            selectedPhoto: e,
                                            allPhoto: images));
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Image.file(
                                      e,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    Visibility(
                                        visible: isMulti,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            // margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                color:
                                                    selectedPhotos.contains(e)
                                                        ? Colors.blue
                                                        : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                shape: BoxShape.rectangle),
                                            height: 20,
                                            width: 20,
                                          ),
                                        ))
                                  ],
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  : const Text(
                      'There is No Photos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Visibility(
                visible: isMulti,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (selectedPhotos.isNotEmpty) {
                              // deletePhotos();
                            }
                          },
                          icon: const Icon(Icons.delete_forever)),
                      IconButton(
                          onPressed: () {
                            EditPhoto editPhoto1 = EditPhoto(
                                image: selectedPhotos,
                                selectedDate: selectedDate);
                            context
                                .toName(Routes.editPhoto, arguments: editPhoto1)
                                .then((value) => retrieveImage(selectedDate));
                          },
                          icon: const Icon(Icons.animation)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.file_upload_outlined))
                    ],
                  ),
                ),
              )
            ],
          )),
          floatingActionButton:  FloatingActionButton(
              onPressed:  (){context.toName(Routes.cameraview);} ,//onTakePictureButtonPressed,
              tooltip: 'Increment',
              child: const Icon( Icons.camera_alt_outlined),
            ),
        );
      },
    );
  }

  
  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      // showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (_) {
      // _showCameraException(e);
      return null;
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (file != null) {
        createPrivateFolder(file.path,file.name);
      }
    });
  }

  Future<String> createPrivateFolder(String path,String xFilename) async {
    Directory appDocumentsDirectory = await getAppDirectory();
    // final appDocumentsDirectory = await getExternalStorageDirectory();
    if (appDocumentsDirectory.existsSync()) {
      Directory logDirectory =
          Directory('${appDocumentsDirectory.path}/PrivateImage');
      if (!logDirectory.existsSync()) {
        await logDirectory.create();
      }
      DateTime now = DateTime.now();
      String month = now.month < 10 ? '0${now.month}' : '${now.month}';
      String day = now.day < 10 ? '0${now.day}' : '${now.day}';
      String currentDateFolderName = '${now.year}-$month-$day';
      final timestampFolder =
          Directory('${logDirectory.path}/$currentDateFolderName');
      if (!timestampFolder.existsSync()) {
        await timestampFolder.create();
      }
      final sourceImage = File(path);
      String imagename='Urton_$xFilename';
      String destinationImagePath =
          '${timestampFolder.path}/$imagename.jpg';
      if (sourceImage.existsSync()) {
        await sourceImage.copy(destinationImagePath);
        // await sourceImage.delete();
      }
    }
    return 'success';
  }

  void retrieveImage(DateTime date) async {
    images = [];
    String month = date.month < 10 ? '0${date.month}' : '${date.month}';
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    String currentDateFolderName = '${date.year}-$month-$day';
    Directory appDocumentsDirectory = await getApplicationSupportDirectory();
    // Directory? appDocumentsDirectory = await getExternalStorageDirectory();
    if (Platform.isIOS) {
      appDocumentsDirectory = await getApplicationDocumentsDirectory();
    }
    if (appDocumentsDirectory.existsSync()) {
      final logDirectory = Directory(
          '${appDocumentsDirectory.path}/PrivateImage/$currentDateFolderName');
      if (logDirectory.existsSync()) {
        final logSubfolders = logDirectory.listSync();
        for (int i = 0; i < logSubfolders.length; i++) {
          var file = logSubfolders[i];
          images.add(File(file.path));
        }
      }
      if (mounted) {
        // BlocProvider.of<HomeScreenProviderBloc>(context)
        //     .add(HomePageStateChange());
      }
      // log(images.toString());
    }
  }
}

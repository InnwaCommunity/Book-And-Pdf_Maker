
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_gallery/models/edit_photo_model.dart';
import 'package:screenshot/screenshot.dart';

class EditPhotoView extends StatefulWidget {
  final EditPhoto editPhoto;
  const EditPhotoView({required this.editPhoto, super.key});

  @override
  State<EditPhotoView> createState() => _EditPhotoViewState();
}

class _EditPhotoViewState extends State<EditPhotoView> {

  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    EditPhoto toeditPhoto=widget.editPhoto;
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, 
          child: const Text('Cancel')),
          TextButton(onPressed: (){
            screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((capturedImage) async {
              savetoFolder(capturedImage).then((value) => Navigator.of(context).pop());
                });
          }, 
          child: const Text('Save'))
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Screenshot(
          //     controller: screenshotController,
          //     child: Container(
          //         padding: const EdgeInsets.all(30.0),
          //         decoration: BoxDecoration(
          //           border: Border.all(color: Colors.blueAccent, width: 5.0),
          //           color: Colors.amberAccent,
          //         ),
          //         child: Stack(
          //           children: [
          //             Image.asset(
          //               'assets/images/app_logo.jpg',
          //             ),
          //             const Positioned(
          //               bottom: 10,
          //               child: Text('This widget will be captured as an image',style: TextStyle(color: Colors.white),
          //               )),
          //           ],
          //         )),
          //   ),
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: toeditPhoto.image.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Container(
                                  color: Colors.blue,
                                  // height: Me,
                                  // width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.file(
                                    
                                    toeditPhoto.image[index],
                                    fit: BoxFit.cover,
                                    // width: double.infinity,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              );
                            }),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> savetoFolder(Uint8List? capturedImage) async {
    if (capturedImage != null) {
      DateTime pdfsaveDate = widget.editPhoto.selectedDate;
      String month = pdfsaveDate.month < 10
          ? '0${pdfsaveDate.month}'
          : '${pdfsaveDate.month}';
      String day =
          pdfsaveDate.day < 10 ? '0${pdfsaveDate.day}' : '${pdfsaveDate.day}';
      String currentDateFolderName = '${pdfsaveDate.year}-$month-$day';
      Directory appDocumentsDirectory = await getApplicationSupportDirectory();
      if (Platform.isIOS) {
        appDocumentsDirectory = await getApplicationDocumentsDirectory();
      }
      final timestampFolder = Directory(
          '${appDocumentsDirectory.path}/PrivateImage/$currentDateFolderName');
      if (!timestampFolder.existsSync()) {
        await timestampFolder.create();
      }
      DateTime now = DateTime.now();
      String destinationImagePath =
          '${timestampFolder.path}/${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}.jpg';
      File imageFile = File(destinationImagePath);
      await imageFile.writeAsBytes(capturedImage);
    }
    return true;
  }
}
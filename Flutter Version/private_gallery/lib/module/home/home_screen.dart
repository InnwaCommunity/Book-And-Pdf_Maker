import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:private_gallery/config/routes.dart';
import 'package:private_gallery/config/routes_ext.dart';
import 'package:private_gallery/models/edit_photo_model.dart';
import 'package:private_gallery/models/note_data_model.dart';
import 'package:private_gallery/models/photo_detail_model.dart';
import 'package:private_gallery/models/subject_data_model.dart';
import 'package:private_gallery/module/home/bloc/home_screen_provider_bloc.dart';
import 'package:private_gallery/util/service/function_service.dart';
import 'dart:developer';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:private_gallery/widget/common_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  late TabController _tabController;
  TextEditingController categoryName = TextEditingController();
  // int _counter = 0;
  List<File> images = [];
  // List<Note> allNotes=[];
  List<File> selectedPhotos = [];
  List<Subject> selectedSubjects = [];
  List<Subject> allSubjects = [];

  bool isMulti = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    retrieveImage(selectedDate);
  }

  @override
  void dispose() {
    categoryName.clear();
    super.dispose();
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
        BlocProvider.of<HomeScreenProviderBloc>(context).add(HomePageStateChange()); 
      } 
      log(images.toString());
    }
  }

  void _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile? captureImage = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 400,
        maxWidth: 400,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.front);
        // if (mounted && captureImage != null) {
        //   context.toName(Routes.photoDetail,
        //                               arguments: ViewPhotoDetail(
        //                                   selectedPhoto: File(captureImage.path), allPhoto: []));
        // }
    if (captureImage != null) {
      if (Platform.isIOS) {
        captureImage = await rotateAndSaveImage(captureImage);
      }
      createPrivateFolder(captureImage.path)
          .then((value) => retrieveImage(DateTime.now()));
    }
  }

  void _writeNote() {
    // context.toName(Routes.writenote).then((value) => _retriveNote);
    showDialog(
      context: context,
      builder: (ext) {
        return AlertDialog(
          title: TextField(
            maxLength: 50,
            controller: categoryName,
            decoration: const InputDecoration(
                label: Text('Fill The Categorie Name'),
                hintText: 'Eg: ပျော်ရွင်ပါစေ'),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (categoryName.text.isNotEmpty) {
                        saveObject();
                      }
                    },
                    child: const Text('Start'))
              ],
            ),
          ],
        );
      },
    );
  }

  void saveObject() {
    Subject sub=Subject(subjectName: categoryName.text,createDate: DateTime.now(),pdfFile: '');
    BlocProvider.of<HomeScreenProviderBloc>(context).add( SaveSubjectEvent(sub: sub));
  }

  void retriveNote() {
    BlocProvider.of<HomeScreenProviderBloc>(context).add(RetrieveAllObject());
  }

  Future<String> createPrivateFolder(String path) async {
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
      String destinationImagePath =
          '${timestampFolder.path}/${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}.jpg';
      if (sourceImage.existsSync()) {
        await sourceImage.copy(destinationImagePath);
        // await sourceImage.delete();
      }
    }
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeScreenProviderBloc, HomeScreenProviderState>(
      listener: (context, state) {
       if (state is SaveSuccessSubject) {
        Navigator.of(context).pop();
          Subject sub =
              Subject(id: state.subId, subjectName: categoryName.text,createDate: DateTime.now(),pdfFile: '');
          context
              .toName(Routes.writenote, arguments: sub)
              .then((value) => retriveNote);
        }
        if (state is DeleteSubjectSuccess) {
          retriveNote();
          successDialog(context,state.message);
        }
        if (state is GetAllNotesSuccessBySubjectId) {
          // Navigator.of(context).pop();
          createPdf(state.generateNotes,state.subs);
        }
        if (state is UpdateCategoriesSuccess) {
          retriveNote();
        }
      },
      child: BlocBuilder<HomeScreenProviderBloc, HomeScreenProviderState>(
        builder: (context, state) {
          if (state is SelectedMultiPhoto) {
            selectedPhotos = state.selectedPhotos;
            isMulti = state.selectedPhotos.isNotEmpty ? state.isMulti : false;
          }
          if (state is GetAllSubject) {
            // alltitle=state.noteList;
            allSubjects = state.titleList;
          }
          if (state is SelectedMultiNote) {
            selectedSubjects = state.selectedNotes;
            isMulti = state.selectedNotes.isNotEmpty ? state.isMulti : false;
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              flexibleSpace: isMulti
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                selectedPhotos = [];
                                isMulti = false;
                                BlocProvider.of<HomeScreenProviderBloc>(context).add(HomePageStateChange());                              },
                              icon: const Icon(Icons.close)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.select_all))
                        ],
                      ),
                    )
                  : Container(),
              title: SizedBox(
                // color: Colors.blue,
                width: MediaQuery.of(context).size.width * 0.5,
                child: DefaultTabController(
                  length: 2,
                  child: Column(children: [
                    TabBar(
                      unselectedLabelColor: Colors.black,
                      isScrollable: true,
                      controller: _tabController,
                      padding: const EdgeInsets.only(
                        top: 30.0,
                      ),
                      indicatorColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (index) {
                        if (_tabController.index == 1) {
                          isMulti=false;
                          selectedPhotos=[];
                          retriveNote();
                          BlocProvider.of<HomeScreenProviderBloc>(context).add(HomePageStateChange()); 
                        }
                        if (_tabController.index == 0) {
                          retrieveImage(selectedDate);
                          isMulti=false;
                          selectedSubjects=[];
                          BlocProvider.of<HomeScreenProviderBloc>(context).add(HomePageStateChange()); 
                        }
                      },
                      tabs: const [
                        Tab(
                          child: Text(
                            'Photo',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Note',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
              actions: [
                isMulti
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            selectDate().then((value) => retrieveImage(value));
                          },
                          icon: const Icon(Icons.date_range),
                        ))
              ],
            ),
            body: Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  privatePhotoWidget(),
                  privateNoteWidget(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _tabController.index == 0 ? _takePicture : _writeNote,
              tooltip: 'Increment',
              child: Icon(_tabController.index == 0
                  ? Icons.camera_alt_outlined
                  : Icons.edit_document),
            ),
          );
        },
      ),
    );
  }

  // void createPdf(List<Note> pdfs){
    
  // }
  void createPdf(List<Note> pdfs,Subject subs) async {
    final pdf = pw.Document(title: subs.subjectName,pageMode: PdfPageMode.fullscreen);
    final directory = await getExternalStorageDirectory();
    File pdfFile;
    var font = await PdfGoogleFonts.abhayaLibreRegular();
    // var data = await rootBundle.load("assets/fonts/Notosan Myanmar UI Bold.ttf");
    // var myFont = pw.Font.ttf(data);
    List<pw.Widget> pdfwidgets = [];
     for (int i = 0; i < pdfs.length; i++) {
          pdfwidgets.add(
            pw.Text(
              pdfs[i].title,
              style: pw.TextStyle(
                fontSize: 25,
                fontWeight: pw.FontWeight.bold,
                font: font
              ),
            ),
          );
          pdfwidgets.add(pw.SizedBox(height: 5));
          pdfwidgets.add(
            pw.Text(
              pdfs[i].notes,
              style:   pw.TextStyle(color: PdfColors.grey,
              // fontWeight: pw.FontWeight.regular,
              fontWeight: pw.FontWeight.bold,
              font: font
              ),
            ),
          );
          pdfwidgets.add(pw.SizedBox(height: 10));
        }
    //     pdfwidgets.add(
    //   pw.Center(child: pw.SizedBox(
    //     child: pw.Image(pw.MemoryImage(
    //       (await rootBundle.load('assets/images/app_logo.jpg'))
    //           .buffer
    //           .asUint8List(),
    //     )),
    //     height: 100,
    //     width: 100,
    //   ),)
    // );
    pdf.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      // pageTheme: ThemeData.dark(),
      build: (pw.Context context) {
        return pdfwidgets;
      }
    ));

    final permissionStatus = await Permission.storage.status;
    if (permissionStatus != PermissionStatus.granted) {
      await Permission.storage.request();

      final file = File("${directory!.path}/${subs.subjectName}.pdf");
      pdfFile= await file.writeAsBytes(await pdf.save());
    } else {
      final file = File("${directory!.path}/${subs.subjectName}.pdf");
      pdfFile= await file.writeAsBytes(await pdf.save());
    }
    Subject updateSub=Subject(id:subs.id, subjectName: subs.subjectName, createDate: subs.createDate, pdfFile: pdfFile.path.toString());
    
    if (mounted) {
      Navigator.of(context).pop();
      BlocProvider.of<HomeScreenProviderBloc>(context).add(UpdateCategories(updateSub: updateSub));
    }
  }

  Widget privatePhotoWidget() {
    return BlocBuilder<HomeScreenProviderBloc, HomeScreenProviderState>(
      builder: (context, state) {
        return Center(
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
                                BlocProvider.of<HomeScreenProviderBloc>(context)
                                    .add(SelectMultiPhoto(
                                        isMulti: true,
                                        selectedPhoto: e,
                                        selectedPhotos: selectedPhotos));
                              },
                              onTap: () {
                                if (isMulti) {
                                  BlocProvider.of<HomeScreenProviderBloc>(
                                          context)
                                      .add(SelectMultiPhoto(
                                          isMulti: true,
                                          selectedPhoto: e,
                                          selectedPhotos: selectedPhotos));
                                } else {
                                  context.toName(Routes.photoDetail,
                                      arguments: ViewPhotoDetail(
                                          selectedPhoto: e, allPhoto: images));
                                  
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
                                              color: selectedPhotos.contains(e)
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
                          if (selectedSubjects.isNotEmpty) {
                            // deleteNotes();
                            
                          }
                        },
                        icon: const Icon(Icons.delete_forever)),
                    IconButton(onPressed: () {
                          EditPhoto editPhoto1=EditPhoto(image: selectedPhotos, selectedDate: selectedDate);
                          context.toName(Routes.editPhoto ,arguments: editPhoto1).then((value) => retrieveImage(selectedDate));
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
        ));
      },
    );
  }

  // void editPhotos() async{

  // }

  void downloadPdf() async {
    final pdf = pw.Document();
    // final output = await getTemporaryDirectory();
    final directory = await getExternalStorageDirectory();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        }));
        

      // final img=await rootBundle.load('assets/images/app_logo.jpg');
      // final imageBytes=img.buffer.asUint8List();
      // pw.Image image1=pw.Image(pw.MemoryImage(imageBytes));
      
      // pdf.addPage(pw.Page(build: (pw.Context context){
      //   return pw.Container(alignment: pw.Alignment.center,
      // height: 200,
      // child: image1);
      // }));
      final permissionStatus = await Permission.storage.status;
      if (permissionStatus != PermissionStatus.granted) {
        await Permission.storage.request();
        // final logo = File("${directory!.path}/applogo.pdf");
        // await logo.writeAsBytes(await pdf.save());
        
  final file = File("${directory!.path}/sweet.pdf");
      // final file = File("$logDirectory/example.pdf");
      await file.writeAsBytes(await pdf.save());
      } else {
        // final logo = File("${directory!.path}/applogo.pdf");
        // await logo.writeAsBytes(await pdf.save());

        
  final file = File("${directory!.path}/sweet.pdf");
      // final file = File("$logDirectory/example.pdf");
      await file.writeAsBytes(await pdf.save());
      }
      

      if (mounted) {
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Success'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text('OK'))
            ],
          );
      });
      }
  }

  void deleteNotes(BuildContext cont){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Delete Categories'),
        content: const Text('Are You Sure Delete Forever This Categories'),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: const Text('Cancel')),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            isMulti=false;
            BlocProvider.of<HomeScreenProviderBloc>(cont).add(DeleteSubject(selectedSubjects: selectedSubjects));
          }, child: const Text('Ok'))
        ],
      );
    });
  }

  Widget privateNoteWidget() {
    return BlocBuilder<HomeScreenProviderBloc, HomeScreenProviderState>(
      builder: (context, state) {
        return Center(
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
            allSubjects.isNotEmpty
                ? Expanded(
                  child: GridView.count(
                    // childAspectRatio: 1,
                    crossAxisCount: 3,
                    children: allSubjects.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GestureDetector(
                        onLongPress: () {
                          BlocProvider.of<HomeScreenProviderBloc>(context)
                              .add(SelectMultiNote(
                                  isMulti: true,
                                  selectedNote: e,
                                  selectedNotes: selectedSubjects));
                        },
                        onTap: () {
                          if (isMulti) {
                            BlocProvider.of<HomeScreenProviderBloc>(
                                    context)
                                .add(SelectMultiNote(
                                    isMulti: true,
                                    selectedNote: e,
                                    selectedNotes: selectedSubjects));
                          } else {
                            context
                                .toName(Routes.writenote, arguments: e)
                                .then((value) {
                                retriveNote();
                                });
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 200,
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 2),
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.circular(20)),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e.subjectName),
                                  )),
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
                                        color: selectedSubjects.contains(e)
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(30),
                                        shape: BoxShape.rectangle),
                                    height: 20,
                                    width: 20,
                                  ),
                                )),
                                Visibility(
                                    visible: !isMulti,
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: e.pdfFile.isEmpty
                                                ? TextButton.icon(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .white)),
                                                    onPressed: () {
                                                      downloadPdffun(e);
                                                    },
                                                    icon: const Icon(
                                                        Icons.download),
                                                    label: const Text(
                                                      'Download',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ))
                                                : TextButton.icon(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .white)),
                                                    onPressed: () {
                                                      context.toName(
                                                          Routes.pdfView,
                                                          arguments: e.pdfFile);
                                                    },
                                                    icon:
                                                        const Icon(Icons.book),
                                                    label: const Text(
                                                      'Read',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ))),
                                  )
                          ],
                        )),
                      );
                      
                      
                    }).toList(),
                  ),
                )
                : const Text(
                    'There is No Notes',
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
                          deleteNotes(context);
                        },
                        icon: const Icon(Icons.delete_forever)),
                    IconButton(
                      onPressed: (){
                        downloadPdf();
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
        ));
      },
    );
  }

  void downloadPdffun(Subject sub){
    BlocProvider.of<HomeScreenProviderBloc>(context)
                              .add(DownLoadPdf(sub: sub));
    showDialog(context: context, 
    barrierDismissible: false,
    builder: (BuildContext context){
      return const AlertDialog(
        icon: CircularProgressIndicator(),
      );
    });
  }

  Future<DateTime> selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.green, // header background
                onPrimary: Colors.white, // header foreground
                onSurface: Theme.of(context)
                    .colorScheme
                    .secondaryContainer, // calendar text
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondaryContainer, // button text color
                ),
              ),
            ),
            child: Localizations.override(
              context: context,
              locale: const Locale('en', 'US'),
              child: child!,
            ),
          );
        });
    if (picked != null) {
      selectedDate = picked;
      return selectedDate;
    } else {
      return selectedDate;
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:printing/printing.dart';
import 'package:private_gallery/models/note_data_model.dart';
import 'package:private_gallery/models/subject_data_model.dart';
import 'package:private_gallery/module/home/bloc/home_screen_provider_bloc.dart';
import 'package:private_gallery/module/write_note/bloc/write_note_state_manangement_bloc.dart';
import 'package:private_gallery/widget/common_dialog.dart';
import 'package:pdf/widgets.dart' as pw;

class WriteNote extends StatefulWidget {
  final Subject subject;
  const WriteNote({required this.subject, super.key});

  @override
  State<WriteNote> createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  TextEditingController noteController1 = TextEditingController();
  TextEditingController titleController1 = TextEditingController();
  TextEditingController noteController2 = TextEditingController();
  TextEditingController titleController2 = TextEditingController();
  TextEditingController noteController3 = TextEditingController();
  TextEditingController titleController3 = TextEditingController();
  TextEditingController noteController4 = TextEditingController();
  TextEditingController titleController4 = TextEditingController();
  TextEditingController noteController5 = TextEditingController();
  TextEditingController titleController5 = TextEditingController();
  UndoHistoryController? undoNoteController = UndoHistoryController();
  UndoHistoryController? undoTitleController = UndoHistoryController();

  // final FocusNode _focusNode = FocusNode();
  // final FocusNode _titleNode = FocusNode();
  bool showundoOrRedo = false;
  bool showIcons = false;
  bool readOnly = false;
  String image = '';
  String title = '';
  String noteBody = '';
  String alarmTime = '';
  DateTime selectedDate = DateTime.now();
  DateTime createdDate = DateTime.now();
  List<Note> selectedNotes = [];

  @override
  void initState() {
    super.initState();
    retrieveNotes(widget.subject, selectedDate);
  }

  void retrieveNotes(Subject sub, DateTime select) {
    String month = select.month < 10 ? '0${select.month}' : '${select.month}';
    String day = select.day < 10 ? '0${select.day}' : '${select.day}';
    String date = '${select.year}-$month-$day';
    BlocProvider.of<WriteNoteStateManangementBloc>(context)
        .add(RetrieveNoteWithSubjectId(subjectId: sub.id!, createdData: date));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteNoteStateManangementBloc,
        WriteNoteStateManangementState>(
      listener: (context, state) {
        if (state is SaveNoteSuccess) {
          Navigator.of(context).pop();
        } else if (state is SaveNoteUnSuccess) {
          failDialog(context, state.message);
        }

        if (state is RetrieveNoteSuccessWithTitle) {
          selectedNotes = state.selectedNotes;
          if (selectedNotes.isNotEmpty) {
            readOnly=true;
            for (var i = 0; i < selectedNotes.length; i++) {
              if (i == 0) {
                titleController1.text = selectedNotes[0].title;
                noteController1.text = selectedNotes[0].notes;
              }
              if (i == 1) {
                titleController2.text = selectedNotes[1].title;
                noteController2.text = selectedNotes[1].notes;
              }
              if (i == 2) {
                titleController3.text = selectedNotes[2].title;
                noteController3.text = selectedNotes[2].notes;
              }
              if (i == 3) {
                titleController4.text = selectedNotes[3].title;
                noteController4.text = selectedNotes[3].notes;
              }
              if (i == 4) {
                titleController5.text = selectedNotes[4].title;
                noteController5.text = selectedNotes[4].notes;
              }
            }
          } else {
            readOnly=false;
            ///clear title and note body
            titleController1.clear();
            titleController2.clear();
            titleController3.clear();
            titleController4.clear();
            titleController5.clear();

            noteController1.clear();
            noteController2.clear();
            noteController3.clear();
            noteController4.clear();
            noteController5.clear();
            selectedNotes = [
              Note(
                  subjectId: widget.subject.id!,
                  notes: noteController1.text,
                  title: titleController1.text,
                  createDate: selectedDate.toString())
            ];
          }
        }
      },
      child: BlocBuilder<WriteNoteStateManangementBloc,
          WriteNoteStateManangementState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.subject.subjectName),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        selectDate().then((value) =>
                            retrieveNotes(widget.subject, selectedDate));
                      },
                      icon: const Icon(Icons.date_range),
                    )),
                Visibility(
                  visible: showIcons,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            saveNote(widget.subject.id!, selectedDate, null);
                            Subject noteUpdate=Subject(id:widget.subject.id,subjectName: widget.subject.subjectName,createDate: widget.subject.createDate,pdfFile: '');
                            BlocProvider.of<HomeScreenProviderBloc>(context).add(UpdateCategories(updateSub: noteUpdate));
                          },
                          icon: const Icon(Icons.done))
                    ],
                  ),
                )
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: index == 0
                                  ? titleController1
                                  : index == 1
                                      ? titleController2
                                      : index == 2
                                          ? titleController3
                                          : index == 3
                                              ? titleController4
                                              : index == 4
                                                  ? titleController5
                                                  : null,
                              maxLines: null,
                              readOnly: readOnly,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                
                              ),
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                showIcons = true;
                                BlocProvider.of<WriteNoteStateManangementBloc>(
                                        context)
                                    .add(ChangeEventOfBotton(
                                        showBotton: showIcons));
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: index == 0
                                  ? noteController1
                                  : index == 1
                                      ? noteController2
                                      : index == 2
                                          ? noteController3
                                          : index == 3
                                              ? noteController4
                                              : index == 4
                                                  ? noteController5
                                                  : null,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              readOnly: readOnly,
                              onChanged: (value) {
                                showIcons = true;
                                BlocProvider.of<WriteNoteStateManangementBloc>(
                                        context)
                                    .add(ChangeEventOfBotton(
                                        showBotton: showIcons));
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type here...',
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      );
                    },
                    childCount: selectedNotes.length,
                  ),
                ),
              ],
            ),
                  // BlocBuilder<WriteNoteStateManangementBloc,
                  //     WriteNoteStateManangementState>(
                  //   builder: (context, state) {
                  //     return (undoNoteController != null ||
                  //                 undoTitleController != null) &&
                  //             showIcons
                  //         ? Align(
                  //             alignment: Alignment.bottomCenter,
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //               children: [
                  //                 // ListView()
                  //                 // ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount)
                  //                 IconButton(
                  //                     onPressed: () {
                  //                       if (_titleNode.hasFocus) {
                  //                         if (undoTitleController != null) {
                  //                           undoTitleController!.undo();
                  //                         }
                  //                       } else {
                  //                         if (undoNoteController != null) {
                  //                           undoNoteController!.undo();
                  //                         }
                  //                       }
                  //                     },
                  //                     icon: const Icon(Icons.undo)),
                  //                 IconButton(
                  //                     onPressed: () {
                  //                       // if (undoNoteController != null) {
                  //                       //   undoNoteController!.undo();
                  //                       // }
                  //                     },
                  //                     icon: const Icon(Icons.alarm_add)),
                  //                 IconButton(
                  //                     onPressed: () {
                  //                       if (_titleNode.hasFocus) {
                  //                         if (undoTitleController != null) {
                  //                           undoTitleController!.redo();
                  //                         }
                  //                       } else {
                  //                         if (undoNoteController != null) {
                  //                           undoNoteController!.redo();
                  //                         }
                  //                       }
                  //                       // if (undoNoteController != null) {
                  //                       //   undoNoteController!.redo();
                  //                       // }
                  //                     },
                  //                     icon: const Icon(Icons.redo)),
                  //                 // IconButton(
                  //                 //     onPressed: () {
                  //                 //     },
                  //                 //     icon: const Icon(Icons.photo)),
                  //                 // IconButton(
                  //                 //     onPressed: () {
                  //                 //       takePicture();
                  //                 //     },
                  //                 //     icon: const Icon(Icons.camera_alt)),
                  //               ],
                  //             ))
                  //         : Container();
                  //   },
                  // ),
            floatingActionButton: readOnly || selectedNotes.length != 5 ? FloatingActionButton(
              onPressed: () {
                if (readOnly) {
                  readOnly=false;
                  BlocProvider.of<WriteNoteStateManangementBloc>(context)
                      .add(AddNewNoteEvent(selectedNotes: selectedNotes));
                } else {
                  if (selectedNotes.length < 6) {
                  Note addnew = Note(
                      subjectId: widget.subject.id!,
                      title: '',
                      notes: '',
                      createDate: selectedDate.toString());
                  selectedNotes.add(addnew);
                  BlocProvider.of<WriteNoteStateManangementBloc>(context)
                      .add(AddNewNoteEvent(selectedNotes: selectedNotes));
                }
                }
              },
              child: readOnly ?  const Icon(Icons.edit) : selectedNotes.length == 5 ? Container() :const Text('Add') ,
            ) : FloatingActionButton(onPressed: (){
              savePdf();
            }, child: const Text('Save'),),
          );
        },
      ),
    );
  }

  void savePdf() async {
    final pdf = pw.Document(title: widget.subject.subjectName);
    // final output = await getTemporaryDirectory();
    final directory = await getExternalStorageDirectory();
    var data = await rootBundle.load("assets/fonts/Padauk-Regular.ttf");
    var myFont = pw.Font.ttf(data);
    // var font = await PdfGoogleFonts.abhayaLibreRegular();
    // final font = await PdfGoogleFonts.nunitoExtraLight();
    List<pw.Widget> widgets = [];
     for (int i = 0; i < selectedNotes.length; i++) {
          widgets.add(
            pw.Text(
              selectedNotes[i].title,
              style: pw.TextStyle(
                fontSize: 25,
                fontWeight: pw.FontWeight.bold,
                font: myFont
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 5));
          widgets.add(
            pw.Text(
              selectedNotes[i].notes,
              style:  pw.TextStyle(color: PdfColors.grey,
              font: myFont),
            ),
          );
          widgets.add(pw.SizedBox(height: 10));
        }
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return widgets;
      }
    ));

    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         children: [
    //           pw.Padding(
    //               padding: const pw.EdgeInsets.only(left: 10, right: 10),
    //               child: pw.Text(
    //                   'Encryption, Digital Signature, and loading a PDF Document',
    //                   style: const pw.TextStyle(
    //                     fontSize: 25,
    //                   ))),
    //           pw.Container(
    //               padding: const pw.EdgeInsets.only(left: 10, right: 10),
    //               child: pw.Text(
    //                   'Encryption using RC4-40, RC4-128, AES-128, and AES-256 is fully supported using a separate library. This library also provides SHA1 or SHA-256 Digital Signature using your x509 certificate. The graphic signature is represented by a clickable widget that shows Digital Signature information. It implements a PDF parser to load an existing document and add pages, change pages, and add a signature.',
    //                   style: const pw.TextStyle(fontSize: 15))),
    //           pw.Divider(height: 1),
    //         ],
    //       );
    //     }));

    final permissionStatus = await Permission.storage.status;
    if (permissionStatus != PermissionStatus.granted) {
      await Permission.storage.request();

      final file = File("${directory!.path}/ex1.pdf");
      await file.writeAsBytes(await pdf.save());
    } else {
      final file = File("${directory!.path}/ex1.pdf");
      await file.writeAsBytes(await pdf.save());
    }
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

  void saveNote(int subId, DateTime createdDate, DateTime? alarmTime) {
    String month = createdDate.month < 10
        ? '0${createdDate.month}'
        : '${createdDate.month}';
    String day =
        createdDate.day < 10 ? '0${createdDate.day}' : '${createdDate.day}';
    String date = '${createdDate.year}-$month-$day';
    for (var i = 0; i < selectedNotes.length; i++) {
      if (i == 0) {
        selectedNotes[i] = Note(
            subjectId: subId,
            title: titleController1.text,
            notes: noteController1.text,
            createDate: date);
      } else if (i == 1) {
        selectedNotes[i] = Note(
            subjectId: subId,
            title: titleController2.text,
            notes: noteController2.text,
            createDate: date);
      } else if (i == 2) {
        selectedNotes[i] = Note(
            subjectId: subId,
            title: titleController3.text,
            notes: noteController3.text,
            createDate: date);
      } else if (i == 3) {
        selectedNotes[i] = Note(
            subjectId: subId,
            title: titleController4.text,
            notes: noteController4.text,
            createDate: date);
      } else if (i == 4) {
        selectedNotes[i] = Note(
            subjectId: subId,
            title: titleController5.text,
            notes: noteController5.text,
            createDate: date);
      }
    }
    BlocProvider.of<WriteNoteStateManangementBloc>(context)
        .add(SaveNoteEvent(notelist: selectedNotes));
  }
}

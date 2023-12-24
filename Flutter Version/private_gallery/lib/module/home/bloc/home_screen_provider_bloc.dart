import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:private_gallery/SqLHelper/create_subject.dart';
import 'package:private_gallery/SqLHelper/note_create.dart';
import 'package:private_gallery/models/note_data_model.dart';
import 'package:private_gallery/models/subject_data_model.dart';

part 'home_screen_provider_event.dart';
part 'home_screen_provider_state.dart';

class HomeScreenProviderBloc extends Bloc<HomeScreenProviderEvent, HomeScreenProviderState> {
  final DatabaseHelper _databaseHelper;
  // final SubjectDatabase _subjectDatabase;

  HomeScreenProviderBloc(DatabaseHelper databaseHelper,) : _databaseHelper = databaseHelper, super(HomeScreenProviderInitial()) {
    on<HomeScreenProviderEvent>((event, emit) {});
    // on<SelectMultiPhoto>((event, emit) {
    //   if (event.selectedPhotos.contains(event.selectedPhoto)) {
    //     event.selectedPhotos.remove(event.selectedPhoto);
    //   } else {
    //     event.selectedPhotos.add(event.selectedPhoto);
    //   }
    //   emit(SelectedMultiPhoto(isMulti: event.isMulti ,selectedPhotos: event.selectedPhotos,selectedPhoto:event.selectedPhoto));
    // },);

    on<SelectMultiNote>((event, emit) {
      if (event.selectedNotes.contains(event.selectedNote)) {
        event.selectedNotes.remove(event.selectedNote);
      } else {
        event.selectedNotes.add(event.selectedNote);
      }
      emit(SelectedMultiNote(isMulti: event.isMulti ,selectedNotes: event.selectedNotes,selectedNote:event.selectedNote));
    },);

    on<RetrieveAllObject>((event, emit) async{
      DateTime now=DateTime.now();
      List<Subject> notelists= await _databaseHelper.getAllSubjects();
      emit(GetAllSubject(titleList: notelists,now: now));
    },);

    on<SaveSubjectEvent>((event, emit) async{
      int subId= await _databaseHelper.insertSubjects(event.sub);
      emit(SaveSuccessSubject(subId: subId));
    },);

    on<DeleteSubject>((event, emit) async{
      List<Subject> selectedSubjects=event.selectedSubjects;
      for (var i = 0; i < selectedSubjects.length; i++) {
        await _databaseHelper.deleteSubjects(selectedSubjects[i].id!);
        await _databaseHelper.deleteNotesWithSubjectId(selectedSubjects[i].id!);
      }
      emit(const DeleteSubjectSuccess(message: 'Delete Success Categories'));
    },);

    on<HomePageStateChange>((event, emit) {
      DateTime date=DateTime.now();
      emit(HomePageStateChanged(date: date));
    },);

    on<DownLoadPdf>((event,emit) async{
      List<Note> generateNotes= await _databaseHelper.getAllNotesBySubjectId(event.sub.id!);
      emit(GetAllNotesSuccessBySubjectId(generateNotes: generateNotes,subs:event.sub));
    });
    on<UpdateCategories>((event,emit) async{
      int id=await _databaseHelper.updateSubjects(event.updateSub,event.updateSub.id!);
      emit(UpdateCategoriesSuccess(id: id));
    });
  }
}

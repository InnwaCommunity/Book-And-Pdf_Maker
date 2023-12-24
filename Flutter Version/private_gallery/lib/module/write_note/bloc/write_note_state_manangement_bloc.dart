import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_gallery/SqLHelper/note_create.dart';
import 'package:private_gallery/models/note_data_model.dart';
part 'write_note_state_manangement_event.dart';
part 'write_note_state_manangement_state.dart';
class WriteNoteStateManangementBloc extends Bloc<WriteNoteStateManangementEvent, WriteNoteStateManangementState> {
  final DatabaseHelper _databaseHelper;

  WriteNoteStateManangementBloc(DatabaseHelper databaseHelper) 
      : _databaseHelper = databaseHelper, super(WriteNoteStateManangementInitial()) {
    on<WriteNoteStateManangementEvent>((event, emit) {});
    on<ChangeEventOfBotton>((event, emit) {
      emit(ChangeStateOfBotton(showBotton: event.showBotton));
    });
    on<SaveNoteEvent>((event, emit) async {
      try {
        List<Note> notedata = event.notelist;
        String res = await _databaseHelper.deleteNotes(
            notedata[0].subjectId, notedata[0].createDate);
        if (res == '200') {
          for (var i = 0; i < notedata.length; i++) {
            Note insetNote = notedata[i];
            await _databaseHelper.insertNotes(insetNote);
          }
          emit(const SaveNoteSuccess(message: 'Save Success'));
        } else {
          emit(SaveNoteUnSuccess(message: res));
        }
      } on Exception catch (e) {
        emit(SaveNoteUnSuccess(message: e.toString()));
      }
    });

    on<UpdateNoteEvent>((event, emit) async{
      Note updatenote=event.note;
      int res = await _databaseHelper.updateNotes(updatenote, updatenote.id!);
      emit(UpdateNoteSuccess(noteId: res));
    },);

    on<RetrieveNoteWithSubjectId>((event, emit) async{
      List<Note> selectedNotes= await _databaseHelper.searchNotes(event.subjectId,event.createdData);
      emit(RetrieveNoteSuccessWithTitle(selectedNotes: selectedNotes));
    },);

    on<AddNewNoteEvent>((event, emit) {
      DateTime now =DateTime.now();
      emit(AddedNewNote(selectedNotes: event.selectedNotes,now:now));
    },);
  }
}


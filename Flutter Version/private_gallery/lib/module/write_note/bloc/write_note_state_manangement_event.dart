part of 'write_note_state_manangement_bloc.dart';

sealed class WriteNoteStateManangementEvent extends Equatable {
  const WriteNoteStateManangementEvent();

  @override
  List<Object> get props => [];
}

class ChangeEventOfBotton extends  WriteNoteStateManangementEvent{
  final bool showBotton;
  const ChangeEventOfBotton({required this.showBotton});
}

class SaveNoteEvent extends WriteNoteStateManangementEvent {
  final List<Note> notelist;
  const SaveNoteEvent({required this.notelist});
}

class UpdateNoteEvent extends WriteNoteStateManangementEvent{
  final Note note;
  const UpdateNoteEvent({required this.note});
}

class RetrieveNoteWithSubjectId extends WriteNoteStateManangementEvent{
  final int subjectId;
  final String createdData;
  const RetrieveNoteWithSubjectId({required this.subjectId,required this.createdData});
}


class AddNewNoteEvent extends WriteNoteStateManangementEvent{
  final List<Note> selectedNotes;
  const AddNewNoteEvent({required this.selectedNotes});
}
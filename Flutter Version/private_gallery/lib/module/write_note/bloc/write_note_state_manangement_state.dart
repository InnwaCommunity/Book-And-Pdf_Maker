part of 'write_note_state_manangement_bloc.dart';

sealed class WriteNoteStateManangementState extends Equatable {
  const WriteNoteStateManangementState();
  
  @override
  List<Object> get props => [];
}

final class WriteNoteStateManangementInitial extends WriteNoteStateManangementState {}

class ChangeStateOfBotton extends WriteNoteStateManangementState{
  final bool showBotton;
  const ChangeStateOfBotton({required this.showBotton});
}

class SaveNoteSuccess extends WriteNoteStateManangementState{
  final String message;
  const SaveNoteSuccess({required this.message});
}

class SaveNoteUnSuccess extends WriteNoteStateManangementState{
  final String message;
  const SaveNoteUnSuccess({required this.message});
}
//SaveNoteUnSuccess

class UpdateNoteSuccess extends WriteNoteStateManangementState{
  final int noteId;
  const UpdateNoteSuccess({required this.noteId});
}

class RetrieveNoteSuccessWithTitle extends WriteNoteStateManangementState{
  final List<Note> selectedNotes;
  const RetrieveNoteSuccessWithTitle({required this.selectedNotes});
  @override
  List<Object> get props => [selectedNotes];
}

class AddedNewNote extends WriteNoteStateManangementState{
  final List<Note> selectedNotes;
  final DateTime now;
  const AddedNewNote({required this.selectedNotes,required this.now});
  @override
  List<Object> get props => [selectedNotes,now];
}

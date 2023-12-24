part of 'home_screen_provider_bloc.dart';

sealed class HomeScreenProviderState extends Equatable {
  const HomeScreenProviderState();
  
  @override
  List<Object> get props => [];
}

final class HomeScreenProviderInitial extends HomeScreenProviderState {}

final class SelectedMultiPhoto extends HomeScreenProviderState{
  final bool isMulti;
  final List<File> selectedPhotos;
  final File selectedPhoto;
  const SelectedMultiPhoto({required this.isMulti,required this.selectedPhotos,required this.selectedPhoto});
  @override
  List<Object> get props => [isMulti,selectedPhotos,selectedPhoto];
}

final class SelectedMultiNote extends HomeScreenProviderState{
  final bool isMulti;
  final List<Subject> selectedNotes;
  final Subject selectedNote;
  const SelectedMultiNote({required this.isMulti,required this.selectedNotes,required this.selectedNote});
  @override
  List<Object> get props => [isMulti,selectedNotes,selectedNote];
}

class GetAllSubject extends HomeScreenProviderState{
  final DateTime now;
  final List<Subject> titleList;
  const GetAllSubject({ required this.titleList,required this.now});
  @override
  List<Object> get props => [titleList,now];
}

class SaveSuccessSubject extends HomeScreenProviderState{
  final int subId;
  const SaveSuccessSubject({required this.subId});
}

class DeleteSubjectSuccess extends HomeScreenProviderState{
  final String message;
  const DeleteSubjectSuccess({required this.message});
}

class HomePageStateChanged extends HomeScreenProviderState{
  final DateTime date;
  const HomePageStateChanged({required this.date});
  @override
  List<Object> get props => [date];
}

class GetAllNotesSuccessBySubjectId extends HomeScreenProviderState{
  final List<Note> generateNotes;
  final Subject subs;
  const GetAllNotesSuccessBySubjectId({required this.generateNotes,required this.subs});
}

class UpdateCategoriesSuccess extends HomeScreenProviderState{
  final int id;
  const UpdateCategoriesSuccess({required this.id});
}
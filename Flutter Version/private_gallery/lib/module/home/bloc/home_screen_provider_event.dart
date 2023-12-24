part of 'home_screen_provider_bloc.dart';

sealed class HomeScreenProviderEvent extends Equatable {
  const HomeScreenProviderEvent();

  @override
  List<Object> get props => [];
}

class SelectMultiPhoto extends HomeScreenProviderEvent{
  final bool isMulti;
  final List<File> selectedPhotos;
  final File selectedPhoto;
  const SelectMultiPhoto({required this.isMulti,required this.selectedPhotos,required this.selectedPhoto});
  @override
  List<Object> get props => [isMulti,selectedPhotos,selectedPhoto];
}

class SelectMultiNote extends HomeScreenProviderEvent{
  final bool isMulti;
  final List<Subject> selectedNotes;
  final Subject selectedNote;
  const SelectMultiNote({required this.isMulti,required this.selectedNotes,required this.selectedNote});
  @override
  List<Object> get props =>  [isMulti,selectedNotes,selectedNote];
}

class RetrieveAllObject extends HomeScreenProviderEvent{}


class SaveSubjectEvent extends HomeScreenProviderEvent{
  final Subject sub;
  const SaveSubjectEvent({required this.sub});
}

class DeleteSubject extends HomeScreenProviderEvent{
  final List<Subject> selectedSubjects;
  const DeleteSubject({required this.selectedSubjects});
}

class HomePageStateChange extends HomeScreenProviderEvent{}

class DownLoadPdf extends HomeScreenProviderEvent{
  final Subject sub;
  const DownLoadPdf({required this.sub});
}

class UpdateCategories extends HomeScreenProviderEvent{
  final Subject updateSub;
  const UpdateCategories({required this.updateSub});
}

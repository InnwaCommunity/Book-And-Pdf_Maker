part of 'photo_widget_page_bloc.dart';


sealed class PhotoWidgetPageState extends Equatable{
  const PhotoWidgetPageState();

  @override
  List<Object> get props => [];
}

final class PhotoWidgetPageInitial extends PhotoWidgetPageState {}


final class SelectedMultiPhoto extends PhotoWidgetPageState{
  final bool isMulti;
  final List<File> selectedPhotos;
  final File selectedPhoto;
  const SelectedMultiPhoto({required this.isMulti,required this.selectedPhotos,required this.selectedPhoto});
  @override
  List<Object> get props => [isMulti,selectedPhotos,selectedPhoto];
}


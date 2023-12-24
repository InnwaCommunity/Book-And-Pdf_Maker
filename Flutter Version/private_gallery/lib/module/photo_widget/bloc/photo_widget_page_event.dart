part of 'photo_widget_page_bloc.dart';


sealed class PhotoWidgetPageEvent extends Equatable{
  const PhotoWidgetPageEvent();

  @override
  List<Object> get props => [];
}


class SelectMultiPhoto extends PhotoWidgetPageEvent{
  final bool isMulti;
  final List<File> selectedPhotos;
  final File selectedPhoto;
  const SelectMultiPhoto({required this.isMulti,required this.selectedPhotos,required this.selectedPhoto});
  @override
  List<Object> get props => [isMulti,selectedPhotos,selectedPhoto];
}

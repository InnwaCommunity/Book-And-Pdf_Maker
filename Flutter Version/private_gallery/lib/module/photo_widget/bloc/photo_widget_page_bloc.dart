import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'photo_widget_page_event.dart';
part 'photo_widget_page_state.dart';

class PhotoWidgetPageBloc extends Bloc<PhotoWidgetPageEvent, PhotoWidgetPageState> {
  PhotoWidgetPageBloc() : super(PhotoWidgetPageInitial()) {
    on<PhotoWidgetPageEvent>((event, emit) {});
    on<SelectMultiPhoto>((event, emit) {
      if (event.selectedPhotos.contains(event.selectedPhoto)) {
        event.selectedPhotos.remove(event.selectedPhoto);
      } else {
        event.selectedPhotos.add(event.selectedPhoto);
      }
      emit(SelectedMultiPhoto(isMulti: event.isMulti ,selectedPhotos: event.selectedPhotos,selectedPhoto:event.selectedPhoto));
    },);
  }
}

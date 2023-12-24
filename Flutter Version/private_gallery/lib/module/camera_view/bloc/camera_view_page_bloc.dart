import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_view_page_event.dart';
part 'camera_view_page_state.dart';

class CameraViewPageBloc extends Bloc<CameraViewPageEvent, CameraViewPageState> {
  CameraViewPageBloc() : super(CameraViewPageInitial()) {
    on<CameraViewPageEvent>((event, emit) {});
  }
}

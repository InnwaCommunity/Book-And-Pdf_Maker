
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_photo_state_provider_event.dart';
part 'edit_photo_state_provider_state.dart';

class EditPhotoStateProviderBloc extends Bloc<EditPhotoStateProviderEvent, EditPhotoStateProviderState> {
  EditPhotoStateProviderBloc() : super(EditPhotoStateProviderInitial()) {
    on<EditPhotoStateProviderEvent>((event, emit) {});
  }
}

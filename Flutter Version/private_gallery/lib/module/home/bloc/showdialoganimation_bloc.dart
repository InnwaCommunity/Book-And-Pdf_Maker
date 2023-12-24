import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'showdialoganimation_event.dart';
part 'showdialoganimation_state.dart';

class ShowdialoganimationBloc extends Bloc<ShowdialoganimationEvent, ShowdialoganimationState> {
  ShowdialoganimationBloc() : super(ShowdialoganimationInitial()) {
    on<ShowdialoganimationEvent>((event, emit) {});
    on<Changeeventdialog>((event, emit) {
      emit(ChangeStatedialog(horlength: event.horlength));
    },);
  }
}

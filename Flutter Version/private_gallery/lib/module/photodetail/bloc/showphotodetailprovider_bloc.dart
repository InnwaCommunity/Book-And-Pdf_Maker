import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'showphotodetailprovider_event.dart';
part 'showphotodetailprovider_state.dart';

class ShowphotodetailproviderBloc extends Bloc<ShowphotodetailproviderEvent, ShowphotodetailproviderState> {
  ShowphotodetailproviderBloc() : super(ShowphotodetailproviderInitial()) {
    on<ShowphotodetailproviderEvent>((event, emit) {});

    on<StateChangeEvent> ((event, emit) {
      DateTime date=DateTime.now();
      emit(StateChanged(date: date));
    },);
  }
}

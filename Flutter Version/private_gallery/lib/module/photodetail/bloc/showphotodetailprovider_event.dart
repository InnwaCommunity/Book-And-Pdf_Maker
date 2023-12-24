part of 'showphotodetailprovider_bloc.dart';

sealed class ShowphotodetailproviderEvent extends Equatable {
  const ShowphotodetailproviderEvent();

  @override
  List<Object> get props => [];
}

class StateChangeEvent extends ShowphotodetailproviderEvent{}

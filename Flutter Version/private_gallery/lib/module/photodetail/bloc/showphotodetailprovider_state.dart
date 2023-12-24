part of 'showphotodetailprovider_bloc.dart';

sealed class ShowphotodetailproviderState extends Equatable {
  const ShowphotodetailproviderState();
  
  @override
  List<Object> get props => [];
}

final class ShowphotodetailproviderInitial extends ShowphotodetailproviderState {}

class StateChanged extends ShowphotodetailproviderState{
  final DateTime date;
  const StateChanged({required this.date});
  @override
  List<Object> get props => [date];
}

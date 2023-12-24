part of 'showdialoganimation_bloc.dart';

sealed class ShowdialoganimationEvent extends Equatable {
  const ShowdialoganimationEvent();

  @override
  List<Object> get props => [];
}

class Changeeventdialog extends ShowdialoganimationEvent{
  final double horlength;
  const Changeeventdialog({required this.horlength});
}

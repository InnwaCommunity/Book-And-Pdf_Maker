part of 'showdialoganimation_bloc.dart';

sealed class ShowdialoganimationState extends Equatable {
  const ShowdialoganimationState();
  
  @override
  List<Object> get props => [];
}

final class ShowdialoganimationInitial extends ShowdialoganimationState {}

class ChangeStatedialog extends ShowdialoganimationState{
  final double horlength;
  const ChangeStatedialog({required this.horlength});
}

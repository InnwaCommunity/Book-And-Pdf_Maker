part of 'edit_photo_state_provider_bloc.dart';

// @immutable
sealed class EditPhotoStateProviderState extends Equatable{
  const EditPhotoStateProviderState();
  
  @override
  List<Object> get props => [];
}

final class EditPhotoStateProviderInitial extends EditPhotoStateProviderState {}

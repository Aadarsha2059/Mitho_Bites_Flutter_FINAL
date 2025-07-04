import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdating extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final UserEntity user;
  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserEntity updatedUser;
  const UpdateProfile(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

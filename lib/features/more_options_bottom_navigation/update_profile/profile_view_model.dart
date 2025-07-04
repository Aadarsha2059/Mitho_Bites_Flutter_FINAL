import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/update_profile/profile_state.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/update_profile/profile_event.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_get_current_usecase.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_update_usecase.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileState _state = ProfileInitial();
  ProfileState get state => _state;

  final UserGetCurrentUsecase _getCurrentUser = serviceLocator<UserGetCurrentUsecase>();
  final UserUpdateUsecase _updateUser = serviceLocator<UserUpdateUsecase>();

  void onEvent(ProfileEvent event) {
    if (event is LoadProfile) {
      _loadProfile();
    } else if (event is UpdateProfile) {
      _updateProfile(event.updatedUser);
    }
  }

  Future<void> _loadProfile() async {
    _state = ProfileLoading();
    notifyListeners();
    final result = await _getCurrentUser();
    result.fold(
      (failure) {
        _state = ProfileError(failure.message);
        notifyListeners();
      },
      (user) {
        _state = ProfileLoaded(user);
        notifyListeners();
      },
    );
  }

  Future<void> _updateProfile(UserEntity user) async {
    _state = ProfileUpdating();
    notifyListeners();
    final result = await _updateUser(user);
    result.fold(
      (failure) {
        _state = ProfileError(failure.message);
        notifyListeners();
      },
      (updatedUser) {
        _state = ProfileUpdateSuccess(updatedUser);
        notifyListeners();
      },
    );
  }
}

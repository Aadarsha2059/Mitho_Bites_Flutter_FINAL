import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/core/common/snackbar/my_snackbar.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_register_usecase.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUsecase _userRegisterUsecase;

  RegisterViewModel(this._userRegisterUsecase)
      : super(const RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _userRegisterUsecase(
        RegisterUserParams(
          fullname: event.fullname,
          username: event.username,
          password: event.password,
          phone: event.phone,
          address: event.address,
          email: event.email,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, isSuccess: false));
          
          // Show specific error messages
          String errorMessage = failure.message;
          if (errorMessage.contains('timeout')) {
            errorMessage = 'Registration is taking longer than expected. Please try again.';
          } else if (errorMessage.contains('Username already exists')) {
            errorMessage = 'This username is already taken. Please choose a different one.';
          } else if (errorMessage.contains('Email already exists')) {
            errorMessage = 'This email is already registered. Please use a different email.';
          } else if (errorMessage.contains('server not responding')) {
            errorMessage = 'Server is not responding. Please check your connection and try again.';
          }
          
          showMySnackBar(
            context: event.context,
            message: errorMessage,
            color: Colors.red,
          );
        },
        (success) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
          
          // Show success message
          showMySnackBar(
            context: event.context,
            message: 'Registration successful! Please login with your credentials.',
            color: Colors.green,
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      showMySnackBar(
        context: event.context,
        message: 'An unexpected error occurred. Please try again.',
        color: Colors.red,
      );
    }
  }
}

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
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: l.message,
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration successful",
        );
      },
    );
  }
}

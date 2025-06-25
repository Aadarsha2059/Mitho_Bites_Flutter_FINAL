import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_login_usecase.dart';
import 'package:fooddelivery_b/core/common/snackbar/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/user/presentation/view/register_view.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(const LoginState.initial()) {
    on<LoginWithUsernameAndPasswordEvent>(_onLogin);
    on<NavigateToRegisterViewEvent>(_onNavigateToRegister);
    on<NavigateToHomeViewEvent>(_onNavigateToHome);
  }

  Future<void> _onLogin(
    LoginWithUsernameAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUsecase(
      LoginParams(username: event.username, password: event.password),
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
          message: 'Login successful!',
          color: Colors.green,
        );
        // Navigation to home can be handled in the UI using BlocListener
      },
    );
  }

  void _onNavigateToRegister(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    Navigator.of(
      event.context,
    ).push(MaterialPageRoute(builder: (context) => RegisterView()));
  }

  void _onNavigateToHome(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    Navigator.of(event.context).pushReplacementNamed('/home');
  }
}

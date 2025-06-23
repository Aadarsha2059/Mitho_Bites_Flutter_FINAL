import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/core/common/snackbar/my_snackbar.dart';
import 'package:fooddelivery_b/features/home/presentation/view/home_view.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_login_usecase.dart';
import 'package:fooddelivery_b/features/user/presentation/view/register_view.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_view_model.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(const LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
    on<LoginWithUsernameAndPasswordEvent>(_onLoginWithUsernameAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<RegisterViewModel>(),
              ),
            ],
            child: RegisterView(),
          ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: this,
            child: HomeView(loginViewModel: this),
          ),
        ),
      );
    }
  }

  void _onLoginWithUsernameAndPassword(
    LoginWithUsernameAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginParams(username: event.username, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        if (event.context.mounted) {
          showMySnackBar(
            context: event.context,
            message: 'Invalid credentials. Please try again.',
            color: Colors.red,
          );
        }
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        if (event.context.mounted) {
          showMySnackBar(
            context: event.context,
            message: 'Login successful!',
            color: Colors.green,
          );
          add(NavigateToHomeViewEvent(context: event.context));
        }
      },
    );
  }
}

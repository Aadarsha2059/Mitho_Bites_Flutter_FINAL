import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/splash/presentation/view_model/splash_state.dart';

class SplashViewModel extends Cubit<SplashState> {
  SplashViewModel() : super(SplashInitial());

  void startTimer() {
    Timer(const Duration(seconds: 5), () {
      emit(SplashNavigateToLogin());
    });
  }
}

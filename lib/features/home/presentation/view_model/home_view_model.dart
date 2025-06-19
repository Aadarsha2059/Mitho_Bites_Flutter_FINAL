import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';

class HomeViewModel extends Cubit<HomeState> {
  final LoginViewModel loginViewModel;

  HomeViewModel({required this.loginViewModel}) : super(HomeState.initial());

  void onTapTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: loginViewModel,
              child:  LoginView(),
            ),
          ),
          (route) => false,
        );
      }
    });
  }
}

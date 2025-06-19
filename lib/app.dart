import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';
import 'package:fooddelivery_b/features/user/presentation/view/register_view.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/theme/theme_data.dart';
import 'package:fooddelivery_b/view/about_us_view.dart';
import 'package:fooddelivery_b/view/dashboard_view.dart';
import 'package:fooddelivery_b/view/forgot_password_view.dart';
import 'package:fooddelivery_b/view/sign_up_view.dart';
import 'package:fooddelivery_b/view/users_profile_view.dart';
import 'package:fooddelivery_b/view/menu_view.dart';
import 'package:fooddelivery_b/view/more_view.dart';
import 'package:fooddelivery_b/view/partypalace_view.dart';
import 'package:fooddelivery_b/view/splash_screen_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fooddelivery_b/app/service_locator/service_locator.dart';

//Import the theme

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mitho Bites',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: BlocProvider.value(
        value: serviceLocator<LoginViewModel>(),
        child: LoginView(),
      ),
    );
  }
}

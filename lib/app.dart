import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/splash/presentation/view/splash_screen_view.dart';
import 'package:fooddelivery_b/theme/theme_data.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/splash/presentation/view_model/splash_screen_view_model.dart';

//Import the theme

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mitho Bites',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: BlocProvider(
        create: (context) => serviceLocator<SplashViewModel>(),
        child: const SplashScreenView(),
      ),
    );
  }
}

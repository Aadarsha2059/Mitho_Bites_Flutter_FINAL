import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/splash/presentation/view_model/splash_screen_view_model.dart';
import 'package:fooddelivery_b/features/splash/presentation/view_model/splash_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';
import 'package:lottie/lottie.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<SplashViewModel>().startTimer();

    // Text slide + fade animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginView()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.orangeAccent.shade100,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffB81736), // Red
                Color(0xff281537), // Dark Maroon
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/splash_food.json',
                  height: 180,
                  repeat: true,
                  animate: true,
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _textSlideAnimation,
                  child: const Column(
                    children: [
                      Text(
                        "Mitho Bites",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Delicious foods at affordable price",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

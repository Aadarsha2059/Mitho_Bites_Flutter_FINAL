import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_view_model.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class HomeView extends StatelessWidget {
  final LoginViewModel loginViewModel;

  const HomeView({super.key, required this.loginViewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeViewModel(loginViewModel: loginViewModel),
      child: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          final vm = context.read<HomeViewModel>();

          return Scaffold(
            body: state.views[state.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: vm.onTapTapped,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
              ],
            ),
          );
        },
      ),
    );
  }
}

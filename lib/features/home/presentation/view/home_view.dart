import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_view_model.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_view_model.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_view_model.dart';

class HomeView extends StatelessWidget {
  final LoginViewModel loginViewModel;

  const HomeView({super.key, required this.loginViewModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeViewModel(loginViewModel: loginViewModel),
        ),
        BlocProvider(
          create: (_) {
            try {
              return serviceLocator<CategoryViewModel>();
            } catch (e) {
              print('Error creating CategoryViewModel: $e');
              // Return a default CategoryViewModel if service locator fails
              return CategoryViewModel(
                getCategoriesUsecase: serviceLocator<GetCategoriesUsecase>(),
              );
            }
          },
        ),
        BlocProvider(
          create: (_) => serviceLocator<RestaurantViewModel>(),
        ),
      ],
      child: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return const DashboardView();
        },
      ),
    );
  }
}

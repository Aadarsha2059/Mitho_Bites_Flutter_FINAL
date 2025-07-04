import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_view_model.dart';
import 'package:fooddelivery_b/features/home/presentation/view_model/home_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/features/home/presentation/view/bottom_view/dashboard_view.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_view_model.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_event.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_view_model.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/get_restaurants_usecase.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_event.dart';

// Simple static storage for current username
class UserSession {
  static String? _currentUsername;
  
  static void setUsername(String username) {
    _currentUsername = username;
  }
  
  static String getUsername() {
    return _currentUsername ?? 'User';
  }
}

class HomeView extends StatelessWidget {
  final LoginViewModel loginViewModel;

  const HomeView({super.key, required this.loginViewModel});

  // Simple method to get current username from login data
  String _getCurrentUsername() {
    return UserSession.getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeViewModel(loginViewModel: loginViewModel),
        ),
        BlocProvider<CategoryViewModel>(
          create: (_) {
            try {
              final categoryViewModel = serviceLocator<CategoryViewModel>();
              // Ensure categories are loaded for every user
              categoryViewModel.add(const LoadCategoriesEvent());
              return categoryViewModel;
            } catch (e) {
              print('Error creating CategoryViewModel: $e');
              // Return a default CategoryViewModel if service locator fails
              final categoryViewModel = CategoryViewModel(
                getCategoriesUsecase: serviceLocator<GetCategoriesUsecase>(),
              );
              categoryViewModel.add(const LoadCategoriesEvent());
              return categoryViewModel;
            }
          },
        ),
        BlocProvider<RestaurantViewModel>(
          create: (_) {
            try {
              final restaurantViewModel = serviceLocator<RestaurantViewModel>();
              // Ensure restaurants are loaded for every user
              restaurantViewModel.add(const LoadRestaurantsEvent());
              return restaurantViewModel;
            } catch (e) {
              print('Error creating RestaurantViewModel: $e');
              // Return a default RestaurantViewModel if service locator fails
              final restaurantViewModel = RestaurantViewModel(
                getRestaurantsUsecase: serviceLocator<GetRestaurantsUsecase>(),
              );
              restaurantViewModel.add(const LoadRestaurantsEvent());
              return restaurantViewModel;
            }
          },
        ),
      ],
      child: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return DashboardView(currentUsername: _getCurrentUsername());
        },
      ),
    );
  }
}

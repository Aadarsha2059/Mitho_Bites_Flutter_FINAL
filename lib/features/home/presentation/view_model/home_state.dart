import 'package:flutter/widgets.dart';
import 'package:fooddelivery_b/features/home/presentation/view/bottom_view/account_view.dart';
import 'package:fooddelivery_b/view/dashboard_view.dart';

class HomeState {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  factory HomeState.initial() {
    return const HomeState(
      selectedIndex: 0,
      views: [DashboardView(), AccountView()],
    );
  }

  HomeState copyWith({int? selectedIndex, List<Widget>? views}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }
}

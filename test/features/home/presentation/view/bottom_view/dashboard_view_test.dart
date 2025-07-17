import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/home/presentation/view/bottom_view/dashboard_view.dart';
void main() {
  testWidgets('DashboardView shows dashboard title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardView()));
    expect(find.textContaining('Dashboard'), findsWidgets);
  });
} 
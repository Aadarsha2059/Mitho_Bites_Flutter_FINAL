import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/menu/menu_view.dart';
void main() {
  testWidgets('MenuView shows menu title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MenuView()));
    expect(find.textContaining('Menu'), findsWidgets);
  });
} 
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';
void main() {
  testWidgets('LoginView shows username and password fields', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginView()));
    expect(find.byKey(const ValueKey('username')), findsWidgets);
    expect(find.byKey(const ValueKey('password')), findsWidgets);
  });
} 
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/user/presentation/view/register_view.dart';
void main() {
  testWidgets('RegisterView shows register title', (tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterView()));
    expect(find.textContaining('Register'), findsWidgets);
  });
} 
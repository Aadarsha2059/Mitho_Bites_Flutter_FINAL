import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TextField renders and accepts input', (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: TextField(
              key: const ValueKey('testTextField'),
              controller: controller,
            ),
          ),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('testTextField')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('testTextField')), 'Hello');
    expect(controller.text, 'Hello');
  });
} 
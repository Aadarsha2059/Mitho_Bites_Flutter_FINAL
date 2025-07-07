import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Icon widget renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Icon(Icons.star, key: const ValueKey('starIcon')),
          ),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('starIcon')), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
} 
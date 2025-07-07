import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp builds and shows home widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Home')), 
          body: const Center(child: Text('Hello, Widget Test!')),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Hello, Widget Test!'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
} 
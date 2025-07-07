import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ListTile widget renders with title and subtitle', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Title'),
            subtitle: const Text('Subtitle'),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.info), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });
} 
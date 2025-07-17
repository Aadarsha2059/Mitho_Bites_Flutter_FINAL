import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/more_view.dart';
void main() {
  testWidgets('MoreView shows more title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MoreView()));
    expect(find.textContaining('More'), findsWidgets);
  });
} 
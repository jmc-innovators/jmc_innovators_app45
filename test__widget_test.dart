import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jmc_innovators_learning_platform/main.dart';

void main() {
  testWidgets('App builds without throwing', (WidgetTester tester) async {
    await tester.pumpWidget(const JmcInnovatorsApp());

    // The app starts on the splash screen; just verify it renders a
    // MaterialApp and doesn't crash during the first frame.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

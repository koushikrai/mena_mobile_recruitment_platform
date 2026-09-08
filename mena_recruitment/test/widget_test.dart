import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mena_recruitment/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MenaRecruitmentApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsWidgets);
    // Let async mock fetch delay (500ms) resolve
    await tester.pump(const Duration(milliseconds: 600));
  });
}

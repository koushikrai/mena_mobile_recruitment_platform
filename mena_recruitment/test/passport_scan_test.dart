import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/features/vault/presentation/screens/passport_scan_screen.dart';

void main() {
  testWidgets('PassportScanScreen displays Retake Scan button and opens source sheet', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PassportScanScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial fields
    expect(find.text('Smart Travel Document Verification'), findsOneWidget);
    expect(find.text('N8492014'), findsOneWidget);
    expect(find.text('Retake Scan / Upload Gallery'), findsOneWidget);

    // Tap "Retake Scan / Upload Gallery"
    final retakeButton = find.widgetWithText(OutlinedButton, 'Retake Scan / Upload Gallery');
    expect(retakeButton, findsOneWidget);
    await tester.tap(retakeButton);
    await tester.pumpAndSettle();

    // Verify bottom sheet modal appears with the 3 scan/upload options
    expect(find.text('Retake Scan / Upload Bio-Page'), findsOneWidget);
    expect(find.text('Capture with Camera'), findsOneWidget);
    expect(find.text('Upload from Device / Gallery'), findsOneWidget);
    expect(find.text('Load Demo Sample (Saudi / GCC Valid)'), findsOneWidget);

    // Tap demo sample option to verify simulation
    await tester.tap(find.text('Load Demo Sample (Saudi / GCC Valid)'));
    await tester.pump(); // Start scanning progress
    await tester.pump(const Duration(milliseconds: 1000)); // Finish delay
    await tester.pumpAndSettle();

    // Verify passport data was updated with K-prefix sample passport
    expect(find.text('KHALID ABDEL-RAHMAN HASSAN'), findsOneWidget);
    expect(find.text('🇸🇦 Saudi (SAU)'), findsOneWidget);
  });
}

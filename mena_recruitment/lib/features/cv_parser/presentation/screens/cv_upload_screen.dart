import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cv_upload_provider.dart';
import '../widgets/ai_features_card.dart';
import '../widgets/upload_drop_zone.dart';

class CVUploadScreen extends ConsumerWidget {
  const CVUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isParsing = ref.watch(isParsingProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF0F1E36)),
        title: const Text(
          'Step 1 of 2: Upload Resume',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Color(0xFF0F1E36),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.white,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Our AI will automatically extract your information to verify GCC quota eligibility.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF0F1E36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            UploadDropZone(
              onTap: () {
                // Mock file selection
                ref.read(cvUploadProvider.notifier).uploadCV(File('dummy.pdf'));
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.link),
              label: const Text('Import from LinkedIn'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            const AIFeaturesCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: isParsing ? null : () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F1E36),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isParsing
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
              : const Text('Parse & Continue to Review', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

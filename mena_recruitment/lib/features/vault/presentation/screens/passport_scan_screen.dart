import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/camera_mrz_viewfinder.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/mrz_verification_panel.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/passport_validity_checker.dart';
import 'package:mena_recruitment/features/vault/providers/passport_scan_provider.dart';

class PassportScanScreen extends ConsumerWidget {
  const PassportScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mrzData = ref.watch(passportScanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Passport Scan'),
        backgroundColor: const Color(0xFF0F1E36),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () {
              ref.read(passportScanProvider.notifier).simulateScan();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CameraMrzViewfinder(),
            const SizedBox(height: 24),
            if (mrzData != null) ...[
              PassportValidityChecker(isValid: mrzData.hasSixMonthsValidity),
              const SizedBox(height: 16),
              MrzVerificationPanel(mrzData: mrzData),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F1E36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: mrzData != null ? () {} : null,
                  child: const Text('Confirm & Save to Vault', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.read(passportScanProvider.notifier).clear();
                },
                child: const Text('Retake Scan', style: TextStyle(color: Color(0xFF0F1E36))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

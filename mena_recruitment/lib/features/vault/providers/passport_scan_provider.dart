import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/domain/passport_mrz_entity.dart';
import 'package:mena_recruitment/features/vault/data/mock_vault_data.dart';

final passportScanProvider = NotifierProvider<PassportScanNotifier, PassportMRZ?>(() {
  return PassportScanNotifier();
});

class PassportScanNotifier extends Notifier<PassportMRZ?> {
  @override
  PassportMRZ? build() => null;

  void simulateScan() {
    state = MockVaultData.mockPassportMRZ;
  }

  void clear() {
    state = null;
  }
}

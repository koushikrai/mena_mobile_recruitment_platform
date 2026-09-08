import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mena_recruitment/features/vault/domain/passport_mrz_entity.dart';
import 'package:mena_recruitment/features/vault/data/mock_vault_data.dart';

part 'passport_scan_provider.g.dart';

@riverpod
class PassportScan extends _$PassportScan {
  @override
  PassportMRZ? build() => null;

  void simulateScan() {
    state = MockVaultData.mockPassportMRZ;
  }

  void clear() {
    state = null;
  }
}

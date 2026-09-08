import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';
import 'package:mena_recruitment/features/vault/data/vault_repository_impl.dart';

final vaultRepoProvider = Provider((ref) => VaultRepositoryImpl());

final certificationsProvider = AsyncNotifierProvider<CertificationsNotifier, List<Certification>>(() {
  return CertificationsNotifier();
});

class CertificationsNotifier extends AsyncNotifier<List<Certification>> {
  @override
  Future<List<Certification>> build() async {
    return ref.watch(vaultRepoProvider).getCertifications();
  }
}

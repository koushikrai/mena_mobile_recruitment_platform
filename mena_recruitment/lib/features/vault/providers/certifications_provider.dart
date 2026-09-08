import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mena_recruitment/features/vault/domain/certification_entity.dart';
import 'package:mena_recruitment/features/vault/data/vault_repository_impl.dart';

part 'certifications_provider.g.dart';

final vaultRepoProvider = Provider((ref) => VaultRepositoryImpl());

@riverpod
class Certifications extends _$Certifications {
  @override
  Future<List<Certification>> build() async {
    return ref.watch(vaultRepoProvider).getCertifications();
  }
}

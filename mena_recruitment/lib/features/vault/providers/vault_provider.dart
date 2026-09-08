import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/data/vault_repository_impl.dart';

part 'vault_provider.g.dart';

final vaultRepositoryProvider = Provider((ref) => VaultRepositoryImpl());

@riverpod
class VaultDocuments extends _$VaultDocuments {
  @override
  Future<List<VaultDocument>> build() async {
    return ref.watch(vaultRepositoryProvider).getDocuments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.watch(vaultRepositoryProvider).getDocuments());
  }
}

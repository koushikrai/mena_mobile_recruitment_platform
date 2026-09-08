import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/data/vault_repository_impl.dart';

final vaultRepositoryProvider = Provider((ref) => VaultRepositoryImpl());

final vaultDocumentsProvider = AsyncNotifierProvider<VaultDocumentsNotifier, List<VaultDocument>>(() {
  return VaultDocumentsNotifier();
});

class VaultDocumentsNotifier extends AsyncNotifier<List<VaultDocument>> {
  @override
  Future<List<VaultDocument>> build() async {
    return ref.watch(vaultRepositoryProvider).getDocuments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.watch(vaultRepositoryProvider).getDocuments());
  }
}

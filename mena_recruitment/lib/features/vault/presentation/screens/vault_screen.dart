import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/profile_strength_dial.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/vault_document_tile.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

class VaultScreen extends ConsumerWidget {
  const VaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(vaultDocumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Vault'),
        backgroundColor: const Color(0xFF0F1E36), // Navy
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shield),
            tooltip: 'AES-256 Encrypted',
            onPressed: () {},
          )
        ],
      ),
      body: documentsAsync.when(
        data: (docs) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ProfileStrengthDial(
                    percentage: 0.85,
                    label: 'Ready for GCC Relocation',
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Missing Credentials',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1E36),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMissingItem('Trade License', '+5%'),
                _buildMissingItem('Driving License', '+10%'),
                const SizedBox(height: 24),
                const Text(
                  'My Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1E36),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return VaultDocumentTile(
                      document: docs[index],
                      onTap: () {},
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F1E36),
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Upload Document', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMissingItem(String name, String boost) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFD97706), size: 20),
          const SizedBox(width: 8),
          Text(name),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD97706).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              boost,
              style: const TextStyle(
                color: Color(0xFFD97706),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

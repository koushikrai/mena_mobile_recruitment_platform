import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
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
            icon: const Icon(Icons.document_scanner),
            tooltip: 'MRZ Scanner',
            onPressed: () => context.push('/vault/passport-scan'),
          ),
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
                const Center(
                  child: ProfileStrengthDial(
                    percentage: 0.85,
                    label: 'Ready for GCC Relocation',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Missing Credentials',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F1E36),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/vault/certifications'),
                      child: const Text('View All Certs'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildMissingItem(context, 'Trade License (SCE)', '+5%'),
                _buildMissingItem(context, 'GCC Driving License', '+10%'),
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
                    final doc = docs[index];
                    return VaultDocumentTile(
                      document: doc,
                      onTap: () {
                        if (doc.category == DocumentCategory.passport) {
                          context.push('/vault/passport-scan');
                        } else {
                          context.push('/vault/certifications');
                        }
                      },
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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) => SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.document_scanner, color: Color(0xFF0F1E36)),
                    title: const Text('Smart Passport OCR Scan'),
                    subtitle: const Text('Extract MRZ code and auto-validate'),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/vault/passport-scan');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.verified, color: Color(0xFF0F1E36)),
                    title: const Text('Add Certification / License'),
                    subtitle: const Text('NEBOSH, OSHA, SCE, DHA'),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/vault/certifications');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_document, color: Color(0xFF0F1E36)),
                    title: const Text('Update Passport Details'),
                    subtitle: const Text('Manage renewal dates and reminders'),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.push('/vault/passport-update');
                    },
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Document', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMissingItem(BuildContext context, String name, String boost) {
    return InkWell(
      onTap: () => context.push('/vault/certifications'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFD97706), size: 20),
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
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
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

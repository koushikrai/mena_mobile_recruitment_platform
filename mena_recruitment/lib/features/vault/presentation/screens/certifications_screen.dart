import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/credential_card.dart';
import 'package:mena_recruitment/features/vault/presentation/widgets/document_category_tabs.dart';
import 'package:mena_recruitment/features/vault/providers/certifications_provider.dart';

class CertificationsScreen extends ConsumerStatefulWidget {
  const CertificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends ConsumerState<CertificationsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Engineering (SCE)', 'Safety (NEBOSH/OSHA)', 'Driving', 'Medical (DHA/MOH)'];

  @override
  Widget build(BuildContext context) {
    final certsAsync = ref.watch(certificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certifications & Licenses'),
        backgroundColor: const Color(0xFF0F1E36),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DocumentCategoryTabs(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onSelected: (val) => setState(() => _selectedCategory = val),
            ),
          ),
          Expanded(
            child: certsAsync.when(
              data: (certs) {
                // Apply filter in a real app, mock is just passing all
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: certs.length,
                  itemBuilder: (context, index) {
                    return CredentialCard(certification: certs[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F1E36),
        onPressed: () {},
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Certification', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

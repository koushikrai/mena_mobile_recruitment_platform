import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/application_filter_provider.dart';
import '../../providers/applications_provider.dart';
import '../widgets/application_card.dart';
import '../widgets/application_filter_tabs.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(applicationFilterProvider);
    final applicationsAsync = ref.watch(applicationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Applications',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Color(0xFF0F1E36),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          applicationsAsync.when(
            data: (apps) => Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  '${apps.length} Active',
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    color: Color(0xFF059669),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ApplicationFilterTabs(
            selectedFilter: selectedFilter,
            onFilterChanged: (f) => ref.read(applicationFilterProvider.notifier).state = f,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: applicationsAsync.when(
              data: (apps) {
                if (apps.isEmpty) {
                  return const Center(
                    child: Text(
                      'No applications found.',
                      style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    return ApplicationCard(application: apps[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/widgets/app_chip.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';

class JobFilterBar extends ConsumerWidget {
  const JobFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(jobFilterProvider);
    final notifier = ref.read(jobFilterProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _FilterPill(
            label: 'Visa Sponsored',
            isSelected: filter.visaSponsored == true,
            onTap: () => notifier.toggleVisaSponsored(),
          ),
          const SizedBox(width: 8),
          _FilterPill(
            label: 'Transferable Iqama',
            isSelected: filter.transferableIqama == true,
            onTap: () => notifier.toggleIqama(),
          ),
          const SizedBox(width: 8),
          _FilterPill(
            label: 'Immediate Hiring',
            isSelected: filter.immediateHiring == true,
            onTap: () => notifier.toggleImmediate(),
          ),
          const SizedBox(width: 8),
          _FilterPill(
            label: 'Housing Included',
            isSelected: filter.housingIncluded == true,
            onTap: () => notifier.toggleHousing(),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppChip(
        label: label,
        backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
        labelColor: isSelected ? Colors.white : AppColors.textPrimary,
        borderColor: isSelected ? AppColors.primary : AppColors.border,
      ),
    );
  }
}

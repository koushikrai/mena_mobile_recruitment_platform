import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';
import 'package:mena_recruitment/core/widgets/country_flag.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';

class GccCountryChips extends ConsumerWidget {
  const GccCountryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(jobFilterProvider);
    final notifier = ref.read(jobFilterProvider.notifier);

    final countries = [
      {'code': 'uae', 'name': 'UAE'},
      {'code': 'sau', 'name': 'KSA'},
      {'code': 'qat', 'name': 'Qatar'},
      {'code': 'kwt', 'name': 'Kuwait'},
      {'code': 'omn', 'name': 'Oman'},
      {'code': 'bhr', 'name': 'Bahrain'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: countries.map((country) {
          final isSelected = filter.selectedCountries.contains(country['code']);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => notifier.toggleCountry(country['code']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    CountryFlag(
                      countryCode: country['code']!,
                      width: 24,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      country['name']!,
                      style: AppTypography.labelLarge.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

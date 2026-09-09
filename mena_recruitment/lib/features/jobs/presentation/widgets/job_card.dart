import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';
import 'package:mena_recruitment/core/widgets/app_card.dart';
import 'package:mena_recruitment/core/widgets/app_chip.dart';
import 'package:mena_recruitment/core/widgets/country_flag.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/providers/bookmark_provider.dart';

class JobCard extends ConsumerWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AppCard(
        onTap: () => context.push('/jobs/${job.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      job.companyLogoUrl,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, color: AppColors.textSecondary),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              job.title,
                              style: AppTypography.headlineSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (job.isVerifiedEmployer)
                            const Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(Icons.verified_user, color: AppColors.amber, size: 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.companyName,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    job.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: job.isBookmarked ? AppColors.primary : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    ref.read(bookmarkProvider.notifier).toggleBookmark(job.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip(
                  label: '${job.city}, ${job.countryCode.toUpperCase()}',
                  icon: CountryFlag(countryCode: job.countryCode, width: 16, height: 12),
                ),
                AppChip(
                  label: job.visaStatus,
                  backgroundColor: AppColors.emerald.withValues(alpha: 0.1),
                  labelColor: AppColors.emerald,
                ),
                if (job.accommodation != 'Not Included')
                  AppChip(
                    label: job.accommodation,
                    icon: const Icon(Icons.home, size: 14, color: AppColors.textSecondary),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${job.currency} ${job.salaryMin.toInt()} - ${job.salaryMax.toInt()}',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Closes ${job.applicationDeadline.difference(DateTime.now()).inDays}d',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

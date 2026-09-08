import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';
import 'package:mena_recruitment/core/widgets/country_flag.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/compensation_matrix.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/compliance_checklist.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/sticky_apply_bar.dart';
import 'package:mena_recruitment/features/jobs/providers/bookmark_provider.dart';
import 'package:mena_recruitment/features/jobs/providers/job_details_provider.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';

class JobDetailsScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsyncValue = ref.watch(jobDetailsProvider(jobId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          if (jobAsyncValue.hasValue && jobAsyncValue.value != null)
            IconButton(
              icon: Icon(
                jobAsyncValue.value!.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: jobAsyncValue.value!.isBookmarked ? AppColors.primary : AppColors.textPrimary,
              ),
              onPressed: () {
                ref.read(bookmarkProvider.notifier).toggleBookmark(jobId);
                // Invalidate family provider to fetch updated bookmark state
                ref.invalidate(jobDetailsProvider(jobId));
              },
            ),
        ],
      ),
      body: jobAsyncValue.when(
        data: (job) => _buildJobDetails(context, job),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading job details: $err')),
      ),
    );
  }

  Widget _buildJobDetails(BuildContext context, Job job) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          job.companyLogoUrl,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, size: 32, color: AppColors.textSecondary),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          job.companyName,
                          style: AppTypography.titleMedium,
                        ),
                        if (job.isVerifiedEmployer) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_user, color: AppColors.amber, size: 18),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.title,
                      style: AppTypography.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.department,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountryFlag(countryCode: job.countryCode, width: 24, height: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${job.city}, ${job.countryCode.toUpperCase()}',
                          style: AppTypography.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompensationMatrix(job: job),
                    const SizedBox(height: 32),
                    ComplianceChecklist(job: job),
                    const SizedBox(height: 32),
                    Text('Job Description', style: AppTypography.headlineSmall),
                    const SizedBox(height: 16),
                    Text(
                      job.jobDescription,
                      style: AppTypography.bodyMedium.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text('Responsibilities', style: AppTypography.titleLarge),
                    const SizedBox(height: 12),
                    ...job.responsibilities.map((req) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6.0, right: 12.0),
                                child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                              ),
                              Expanded(
                                child: Text(req, style: AppTypography.bodyMedium),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    Text('Qualifications', style: AppTypography.titleLarge),
                    const SizedBox(height: 12),
                    ...job.qualifications.map((qual) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 6.0, right: 12.0),
                                child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                              ),
                              Expanded(
                                child: Text(qual, style: AppTypography.bodyMedium),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 32),
                    Text('About ${job.companyName}', style: AppTypography.headlineSmall),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.aboutEmployer,
                            style: AppTypography.bodyMedium.copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.people_outline, color: AppColors.textSecondary, size: 20),
                              const SizedBox(width: 8),
                              Text(job.employerSize, style: AppTypography.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for sticky bar
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: StickyApplyBar(
            onApply: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Application feature coming soon!')),
              );
            },
          ),
        ),
      ],
    );
  }
}

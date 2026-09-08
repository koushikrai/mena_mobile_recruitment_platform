import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';

class CompensationMatrix extends StatelessWidget {
  final Job job;

  const CompensationMatrix({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Compensation & Relocation', style: AppTypography.headlineSmall),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _MatrixCard(
              icon: Icons.attach_money,
              title: job.isTaxFree ? 'Tax-Free Salary' : 'Salary',
              detail: '${job.currency} ${job.salaryMin.toInt()} - ${job.salaryMax.toInt()}',
            ),
            _MatrixCard(
              icon: Icons.flight_takeoff,
              title: 'Visa & Travel',
              detail: job.visaStatus,
            ),
            _MatrixCard(
              icon: Icons.home_work,
              title: 'Accommodation',
              detail: job.accommodation,
            ),
            _MatrixCard(
              icon: Icons.health_and_safety,
              title: 'Benefits',
              detail: job.relocationBenefits.isNotEmpty ? 'Included' : 'Standard',
            ),
          ],
        ),
      ],
    );
  }
}

class _MatrixCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _MatrixCard({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const Spacer(),
          Text(title, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            detail,
            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

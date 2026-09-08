import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';

class ComplianceChecklist extends StatelessWidget {
  final Job job;

  const ComplianceChecklist({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Regulatory & Compliance', style: AppTypography.headlineSmall),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _ChecklistItem(
                title: 'MOFA Attestation',
                isRequired: job.mofaAttestationRequired,
              ),
              const Divider(height: 24),
              _ChecklistItem(
                title: 'GAMCA Medical',
                isRequired: job.gamcaMedicalRequired,
              ),
              const Divider(height: 24),
              _ChecklistItem(
                title: 'Police Clearance Certificate',
                isRequired: job.policeClearanceRequired,
              ),
              if (job.countryCode == 'sau') ...[
                const Divider(height: 24),
                _ChecklistItem(
                  title: 'Transferable Iqama',
                  isRequired: job.iqamaTransferable,
                  icon: job.iqamaTransferable ? Icons.check_circle : Icons.warning_amber,
                  color: job.iqamaTransferable ? AppColors.emerald : AppColors.amber,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String title;
  final bool isRequired;
  final IconData? icon;
  final Color? color;

  const _ChecklistItem({
    required this.title,
    required this.isRequired,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayIcon = icon ?? (isRequired ? Icons.check_circle : Icons.cancel);
    final displayColor = color ?? (isRequired ? AppColors.emerald : AppColors.textSecondary);
    final statusText = isRequired ? 'Required' : 'Not Required';

    return Row(
      children: [
        Icon(displayIcon, color: displayColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: AppTypography.bodyMedium),
        ),
        Text(
          statusText,
          style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

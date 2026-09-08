import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/theme/app_typography.dart';
import 'package:mena_recruitment/core/widgets/app_button.dart';

class RelocationBanner extends StatelessWidget {
  const RelocationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flight_takeoff, color: AppColors.amber),
              const SizedBox(width: 8),
              Text(
                'GCC Fast-Track Visa & Relocation',
                style: AppTypography.labelLarge.copyWith(color: AppColors.amber),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Need help relocating?',
            style: AppTypography.headlineMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Get end-to-end assistance with MOFA attestation, medicals, and flights.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Learn More',
            onPressed: () {},
            type: ButtonType.secondary,
            // Custom styling for secondary button on dark background could be added to AppButton, 
            // but for now relying on default secondary style.
          ),
        ],
      ),
    );
  }
}

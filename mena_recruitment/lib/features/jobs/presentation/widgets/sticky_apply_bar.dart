import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/widgets/app_button.dart';
import 'dart:ui';

class StickyApplyBar extends StatelessWidget {
  final VoidCallback onApply;

  const StickyApplyBar({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.85),
            border: const Border(
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Apply Now',
                    onPressed: onApply,
                    backgroundColor: AppColors.amber,
                    textColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: onApply,
                  child: const Text(
                    'Quick Apply\nwith Smart CV',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

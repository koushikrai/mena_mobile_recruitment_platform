import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int applicationsBadgeCount;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.applicationsBadgeCount = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.0,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: BorderSide(color: Color(0xFFE4BEB8), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(153, 0, 0, 0.04),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Colors.white.withValues(alpha: 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'JOBS', Icons.work_outline_rounded, Icons.work_rounded),
                _buildNavItem(1, 'SECTORS', Icons.category_outlined, Icons.category_rounded),
                _buildNavItem(
                  2,
                  'PIPELINE',
                  Icons.fact_check_outlined,
                  Icons.fact_check_rounded,
                  hasAlertDot: true,
                ),
                _buildNavItem(3, 'VAULT', Icons.badge_outlined, Icons.badge_rounded),
                _buildNavItem(4, 'PROFILE', Icons.account_circle_outlined, Icons.account_circle_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    IconData inactiveIcon,
    IconData activeIcon, {
    bool hasAlertDot = false,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isActive ? activeIcon : inactiveIcon,
                      color: color,
                      size: 24,
                    ),
                    if (hasAlertDot)
                      Positioned(
                        right: -3,
                        top: -1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

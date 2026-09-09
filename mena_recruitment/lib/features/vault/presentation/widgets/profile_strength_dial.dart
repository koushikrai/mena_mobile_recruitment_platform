import 'package:flutter/material.dart';

class ProfileStrengthDial extends StatelessWidget {
  final double percentage;
  final String label;

  const ProfileStrengthDial({
    super.key,
    required this.percentage,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // using a simple CustomPaint or a placeholder since percent_indicator might not be installed yet
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: percentage,
                strokeWidth: 8,
                backgroundColor: const Color(0xFFF8F9FF),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)), // Emerald
              ),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF990000), // Navy
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF990000),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

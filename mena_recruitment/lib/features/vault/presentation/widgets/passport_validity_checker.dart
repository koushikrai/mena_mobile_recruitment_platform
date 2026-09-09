import 'package:flutter/material.dart';

class PassportValidityChecker extends StatelessWidget {
  final bool isValid;

  const PassportValidityChecker({super.key, required this.isValid});

  @override
  Widget build(BuildContext context) {
    final color = isValid ? const Color(0xFF059669) : Colors.red;
    final text = isValid ? 'Valid for GCC Visa' : 'Renewal Required (Under 6 Months)';
    final icon = isValid ? Icons.check_circle : Icons.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

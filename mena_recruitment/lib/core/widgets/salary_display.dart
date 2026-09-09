import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays a formatted salary range with optional tax-free badge.
class SalaryDisplay extends StatelessWidget {
  /// Minimum salary amount.
  final double min;

  /// Maximum salary amount.
  final double max;

  /// Currency code (e.g., 'AED', 'SAR').
  final String currencyCode;

  /// Period of the salary ('mo' or 'yr').
  final String period;

  /// Whether to display a 'Tax-Free' badge.
  final bool isTaxFree;

  const SalaryDisplay({
    super.key,
    required this.min,
    required this.max,
    required this.currencyCode,
    this.period = 'mo',
    this.isTaxFree = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final minStr = formatter.format(min);
    final maxStr = formatter.format(max);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$currencyCode $minStr - $maxStr / $period',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF990000),
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        if (isTaxFree) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF34D399)),
            ),
            child: const Text(
              'Tax-Free',
              style: TextStyle(
                color: Color(0xFF059669), // Emerald
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

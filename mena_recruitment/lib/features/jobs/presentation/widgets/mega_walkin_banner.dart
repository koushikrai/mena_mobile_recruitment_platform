import 'package:flutter/material.dart';

class MegaWalkinBanner extends StatelessWidget {
  final VoidCallback? onViewDetails;

  const MegaWalkinBanner({super.key, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6E0000), Color(0xFF990000), Color(0xFF3A0006)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Contextual refinery background image with luminosity blend
            Positioned.fill(
              child: Opacity(
                opacity: 0.25,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDs-2n5_Xkj2vrxXdOf2fHsOMdsLLjyHxlt2zdSglN6_hNoax51Oy7zvrFWVg5wE92lNPIzitVFTiVUp-oEzavNgACz4k3TFFQCNQNGgNlpPaCeDrr7_Mq0ocBcf18c-rrT9U_qaCpPNt2viUaUq0zWEODqB5wpAV-Ozpd16hE_BTt7YkEfTgsvzhqYmMv99HUKEt5rh4zAPN-01d4GOoIrMoexzML6K8mbSSd0tRvl3_GT5-xT166wmw',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(color: Colors.black26),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header badge + Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'VERIFIED MEGA WALK-IN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Text(
                          '12-14 NOV 2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  const Text(
                    'EXCLUSIVE BY SUHANA',
                    style: TextStyle(
                      color: Color(0xFFFFCDD2),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Oil & Gas Turnaround 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Yanbu & Jubail Industrial Complex, KSA',
                    style: TextStyle(
                      color: Color(0xFFFFEBEE),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 3 Highlights Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile('1,200+', 'VACANCIES'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricTile('Free', 'VISA & FLIGHT'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricTile('Camp', 'FULL LODGING'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Footer: CTA + Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF990000),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        icon: const Text(
                          'View Drive Details',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        label: const Icon(Icons.east_rounded, size: 16),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFCDD2),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

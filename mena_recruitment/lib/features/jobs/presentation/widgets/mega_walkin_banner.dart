import 'dart:async';
import 'package:flutter/material.dart';

class WalkinBannerCardData {
  final String tag;
  final String dates;
  final String eyebrow;
  final String title;
  final String location;
  final List<Color> gradientColors;
  final String imageUrl;
  final List<BannerMetric> metrics;
  final String ctaText;

  const WalkinBannerCardData({
    required this.tag,
    required this.dates,
    required this.eyebrow,
    required this.title,
    required this.location,
    required this.gradientColors,
    required this.imageUrl,
    required this.metrics,
    this.ctaText = 'View Drive Details',
  });
}

class BannerMetric {
  final String value;
  final String label;

  const BannerMetric(this.value, this.label);
}

class MegaWalkinBanner extends StatefulWidget {
  final VoidCallback? onViewDetails;

  const MegaWalkinBanner({super.key, this.onViewDetails});

  @override
  State<MegaWalkinBanner> createState() => _MegaWalkinBannerState();
}

class _MegaWalkinBannerState extends State<MegaWalkinBanner> {
  late final PageController _pageController;
  Timer? _autoSwitchTimer;
  int _currentIndex = 0;

  static const List<WalkinBannerCardData> _bannerCards = [
    WalkinBannerCardData(
      tag: 'VERIFIED MEGA WALK-IN',
      dates: '12-14 NOV 2025',
      eyebrow: 'EXCLUSIVE BY SUHANA',
      title: 'Oil & Gas Turnaround 2025',
      location: 'Yanbu & Jubail Industrial Complex, KSA',
      gradientColors: [Color(0xFF6E0000), Color(0xFF990000), Color(0xFF3A0006)],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDs-2n5_Xkj2vrxXdOf2fHsOMdsLLjyHxlt2zdSglN6_hNoax51Oy7zvrFWVg5wE92lNPIzitVFTiVUp-oEzavNgACz4k3TFFQCNQNGgNlpPaCeDrr7_Mq0ocBcf18c-rrT9U_qaCpPNt2viUaUq0zWEODqB5wpAV-Ozpd16hE_BTt7YkEfTgsvzhqYmMv99HUKEt5rh4zAPN-01d4GOoIrMoexzML6K8mbSSd0tRvl3_GT5-xT166wmw',
      metrics: [
        BannerMetric('1,200+', 'VACANCIES'),
        BannerMetric('Free', 'VISA & FLIGHT'),
        BannerMetric('Camp', 'FULL LODGING'),
      ],
      ctaText: 'View Drive Details',
    ),
    WalkinBannerCardData(
      tag: 'OFFSHORE DRILLING CAMPAIGN',
      dates: '20-22 NOV 2025',
      eyebrow: 'SAUDI ARAMCO APPROVED',
      title: 'Arabian Gulf Offshore Rigs',
      location: 'Ras Tanura & Safaniya Offshore Hub, KSA',
      gradientColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAJYarP0xVBhhl0rVM34nCxgskUfiLR5rcR_1gqTYlxRIQH-hGl2j4tWVecwscmSMk0b337rW42Zq069TPTbrMbDCgFqrvOAKu_6c_HH-C_XgNF-2sCA2mmla7ZZnZLP6KJ8il2rSTXq_henPTAehhKTf6Y1wGmQ2XglLloIVpMrvmnXYvULNMUHvd2aD1kqzDbUHLUrfpRhCsv3HvR63Rm40OLt3uPlY1pFQ9njDX5r3SUpJv9TmOylQ',
      metrics: [
        BannerMetric('850+', 'VACANCIES'),
        BannerMetric('Tax-Free', 'TOP SALARY'),
        BannerMetric('Rotation', '28 / 28 ON-OFF'),
      ],
      ctaText: 'Explore Campaign',
    ),
    WalkinBannerCardData(
      tag: 'METRO & INFRASTRUCTURE',
      dates: '02-04 DEC 2025',
      eyebrow: 'VISION 2030 MEGA PROJECT',
      title: 'NEOM & Red Sea Global',
      location: 'Tabuk & Sindalah Logistics Corridor, KSA',
      gradientColors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFF0D1B2A)],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJ992QdS9CilPYhNuYNFkGwU5BnHG2W7sRwQMB21nJfpnCdP0RmTAtTi0lAWeKS81Nu7QR26Y7kK0JPBzMva_TER6MuPTV1lEJ0fcDj7aMWGiH8ta0vX3k9ia1VphDVwk7-if6ruXF4iZY-skuffMpbicfPMJm7OVXLdUbVhYDSTB8Ttsz0aq2pNO5d6ZmJYiUFx9NCmgQ1aNESg-u-fA7MteMQAf33DVAK5NIEeUz1feWl-mJOleuw',
      metrics: [
        BannerMetric('2,400+', 'VACANCIES'),
        BannerMetric('Family', 'STATUS AVAIL'),
        BannerMetric('Fast Visa', '3-WEEK FLY'),
      ],
      ctaText: 'View NEOM Drive',
    ),
    WalkinBannerCardData(
      tag: 'PETROCHEMICAL EXPANSION',
      dates: '10-12 DEC 2025',
      eyebrow: 'SABIC EXPANSION TIER-1',
      title: 'High-Tech Refinery Overhaul',
      location: 'Al-Jubail Petrochemical Zone, KSA',
      gradientColors: [Color(0xFF590d22), Color(0xFF800f2f), Color(0xFF250902)],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDs-2n5_Xkj2vrxXdOf2fHsOMdsLLjyHxlt2zdSglN6_hNoax51Oy7zvrFWVg5wE92lNPIzitVFTiVUp-oEzavNgACz4k3TFFQCNQNGgNlpPaCeDrr7_Mq0ocBcf18c-rrT9U_qaCpPNt2viUaUq0zWEODqB5wpAV-Ozpd16hE_BTt7YkEfTgsvzhqYmMv99HUKEt5rh4zAPN-01d4GOoIrMoexzML6K8mbSSd0tRvl3_GT5-xT166wmw',
      metrics: [
        BannerMetric('960+', 'VACANCIES'),
        BannerMetric('Overtime', '1.5X PAID'),
        BannerMetric('Medical', 'VIP CLASS A'),
      ],
      ctaText: 'View Expansion',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _autoSwitchTimer?.cancel();
    _autoSwitchTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextIndex = (_currentIndex + 1) % _bannerCards.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoSwitchTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        itemCount: _bannerCards.length,
        itemBuilder: (context, index) {
          final card = _bannerCards[index];
          return _buildCardItem(card, index);
        },
      ),
    );
  }

  Widget _buildCardItem(WalkinBannerCardData card, int cardIndex) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: card.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
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
                opacity: 0.22,
                child: Image.network(
                  card.imageUrl,
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
                            Text(
                              card.tag,
                              style: const TextStyle(
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
                        child: Text(
                          card.dates,
                          style: const TextStyle(
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
                  // Eyebrow
                  Text(
                    card.eyebrow,
                    style: const TextStyle(
                      color: Color(0xFFFFCDD2),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Title
                  Text(
                    card.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle / Location
                  Text(
                    card.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFFFEBEE),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Highlights Grid
                  Row(
                    children: [
                      for (int i = 0; i < card.metrics.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricTile(card.metrics[i].value, card.metrics[i].label),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  // Footer: CTA + Dynamic Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: widget.onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: card.gradientColors.first,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        icon: Text(
                          card.ctaText,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        label: const Icon(Icons.east_rounded, size: 15),
                      ),
                      // Interactive pagination dots matching active card
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_bannerCards.length, (dotIdx) {
                          final isActive = dotIdx == _currentIndex;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                dotIdx,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(left: 4),
                              width: isActive ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          );
                        }),
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFCDD2),
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}


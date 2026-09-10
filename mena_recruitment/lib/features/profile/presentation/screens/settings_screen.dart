import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/widgets/notifications_sheet.dart';
import 'package:mena_recruitment/features/auth/providers/auth_provider.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const containerCrimson = Color(0xFF990000);
  bool _ksaQuota = true;
  bool _uaeQuota = true;
  bool _qatarQuota = true;
  bool _kuwaitQuota = false;
  bool _omanQuota = false;
  bool _bahrainQuota = false;

  bool _whatsappAlerts = true;
  bool _pushAlerts = true;
  bool _emailDigest = false;

  String _selectedLanguage = 'en';

  // Relocation & Salary Preferences
  String _relocationTimeline = 'Within 15 days';
  String _minSalary = 'SAR 15,000 / mo';

  // CV document state
  bool _hasCv = true;
  final String _cvFileName = 'Ahmed_Mansoor_HSE_CV_2026.pdf';

  void _confirmDeleteCv() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFBA1A1A)),
            SizedBox(width: 8),
            Text('Delete CV?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your active CV?\n\nThis will remove your attached resume document. You can upload an updated CV anytime.',
          style: TextStyle(fontSize: 12, color: _ink, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _inkLight)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasCv = false;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ CV deleted from profile. You can upload a new one anytime.'),
                  backgroundColor: Color(0xFFBA1A1A),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete CV'),
          ),
        ],
      ),
    );
  }

  // ── Colours ──────────────────────────────────────────────────────────────
  static const _crimson = Color(0xFF6E0000);
  static const _surface = Color(0xFFF9F9FF);
  static const _white = Colors.white;
  static const _cardLow = Color(0xFFF1F3FD);
  static const _cardMid = Color(0xFFE5E8F2);
  static const _ink = Color(0xFF181C23);
  static const _inkLight = Color(0xFF5A5F67);

  void _editRelocationTimeline() {
    final options = [
      'Immediate (Ready now)',
      'Within 15 days',
      'Within 30 days',
      'Within 60 days',
      '2+ months notice',
    ];
    final customCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Relocation Availability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
  @override
  Widget build(BuildContext context) {
    const lightSurface = Color(0xFFFBF8F8);
    const cardLowest = Colors.white;
    const cardLow = Color(0xFFF4EFF0);
    const cardHigh = Color(0xFFE4DADB);
    const primaryCrimson = Color(0xFF990000);
    const textOnSurface = Color(0xFF181C23);
    const textSecondary = Color(0xFF5A5F67);

    final profileAsync = ref.watch(profileProvider);
    final authState = ref.watch(authStateProvider);
    final profile = profileAsync.value;
    final currentUser = authState.user;
    final candidateName = profile?.fullName ?? currentUser?.fullName ?? 'Ahmed Mansoor Al-Farooq';
    final candidateTitle = profile?.targetTitle ?? 'Senior HSE Supervisor';
    final candidateExp = '${profile?.gccExperience ?? 4} yrs GCC Exp';
    final candidateUid = profile?.uid ?? currentUser?.id ?? 'SUH-GCC-88219';
    final readiness = (profile?.readinessScore ?? 85) / 100.0;
    final readinessPct = '${profile?.readinessScore ?? 85}%';

    return Scaffold(
      backgroundColor: lightSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                color: cardLowest,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFFFD4D4)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.shield, color: containerCrimson, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'GLOBAL JOBS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: primaryCrimson,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Account Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textOnSurface,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications, color: textSecondary, size: 22),
                          onPressed: () => NotificationsSheet.show(context),
                        ),
                        InkWell(
                          onTap: () => context.push(RouteNames.login),
                          borderRadius: BorderRadius.circular(15),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: cardHigh,
                            child: Icon(Icons.person, size: 18, color: primaryCrimson),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Intro Context
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'EXECUTIVE CANDIDATE HUB',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: primaryCrimson,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDAD6).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: primaryCrimson),
                              SizedBox(width: 4),
                              Text(
                                'Qiwa Synchronized',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryCrimson),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Account & Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textOnSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Text(
                      'Manage target GCC mobility quotas, instant recruiter channels, and confidential privacy shields.',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // Candidate Profile Snapshot Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  const CircleAvatar(
                                    radius: 26,
                                    backgroundColor: cardHigh,
                                    child: Icon(Icons.person, size: 30, color: primaryCrimson),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryCrimson,
                                      ),
                                      child: const Icon(Icons.verified, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidateName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: textOnSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$candidateTitle • $candidateExp',
                                      style: const TextStyle(fontSize: 11, color: textSecondary),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: cardHigh,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '#$candidateUid',
                                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF42474F)),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF1F1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Tier 1 Verified',
                                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primaryCrimson),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Integrity meter
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardLow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.verified_user, size: 14, color: primaryCrimson),
                                        SizedBox(width: 4),
                                        Text('Gulf Dossier Integrity', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                                      ],
                                    ),
                                    Text('$readinessPct Verified', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: readiness,
                                    minHeight: 5,
                                    backgroundColor: const Color(0xFFDEE2ED),
                                    valueColor: const AlwaysStoppedAnimation<Color>(primaryCrimson),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('MOHRE & Qiwa credential validation active', style: TextStyle(fontSize: 10, color: textSecondary)),
                                    InkWell(
                                      onTap: () => context.push('/cv/review'),
                                      child: const Row(
                                        children: [
                                          Text('Edit Bio', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryCrimson)),
                                          Icon(Icons.arrow_forward, size: 11, color: primaryCrimson),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Target GCC Work Quotas
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.public, size: 18, color: primaryCrimson),
                              SizedBox(width: 8),
                              Text('Target GCC Work Quotas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Choose destination states where verified recruiters can query your visa pool availability.',
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          const SizedBox(height: 12),

                          _buildCountryToggle('🇸🇦', 'Saudi Arabia (KSA)', 'Eligible for Qiwa • Muqeem Quota', _ksaQuota, (v) => setState(() => _ksaQuota = v)),
                          const SizedBox(height: 8),
                          _buildCountryToggle('🇦🇪', 'United Arab Emirates (UAE)', 'MOHRE Green Visa Quota Open', _uaeQuota, (v) => setState(() => _uaeQuota = v)),
                          const SizedBox(height: 8),
                          _buildCountryToggle('🇶🇦', 'Qatar', 'QatarEnergy Work Visa Pool', _qatarQuota, (v) => setState(() => _qatarQuota = v)),
                          const SizedBox(height: 8),
                          _buildCountryToggle('🇰🇼', 'Kuwait', 'Quota Inactive • Click to enable', _kuwaitQuota, (v) => setState(() => _kuwaitQuota = v)),
                          const SizedBox(height: 8),
                          _buildCountryToggle('🇴🇲', 'Oman', 'Quota Inactive • Click to enable', _omanQuota, (v) => setState(() => _omanQuota = v)),
                          const SizedBox(height: 8),
                          _buildCountryToggle('🇧🇭', 'Bahrain', 'Quota Inactive • Click to enable', _bahrainQuota, (v) => setState(() => _bahrainQuota = v)),
                          const SizedBox(height: 14),

                          // Relocation & Salary Sub-Cards
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('RELOCATION WINDOW', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
                                    Text('Within 15 Days after visa stamp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                  ],
                                ),
                                Icon(Icons.edit_calendar, size: 16, color: primaryCrimson),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('EXPECTED TAX-FREE MIN. SALARY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
                                    Text('SAR 15,000 / AED 15,000 / mo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                  ],
                                ),
                                Icon(Icons.payments, size: 16, color: primaryCrimson),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Alerts & Dispatch Channels
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.notifications_active, size: 18, color: primaryCrimson),
                              SizedBox(width: 8),
                              Text('Alerts & Dispatch Channels', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Direct encrypted notifications for offers, interview requests, and visa issuance.',
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          const SizedBox(height: 12),

                          _buildChannelTile(
                            icon: Icons.chat,
                            iconColor: const Color(0xFF128C7E),
                            iconBg: const Color(0xFF25D366).withValues(alpha: 0.15),
                            title: 'WhatsApp Direct Priority',
                            subtitle: '+966 50 ••• ••34 (Saudi Certified)',
                            note: 'Real-time interview invites & embassy drops',
                            value: _whatsappAlerts,
                            onChanged: (v) => setState(() => _whatsappAlerts = v),
                          ),
                          const SizedBox(height: 8),
                          _buildChannelTile(
                            icon: Icons.mark_chat_unread,
                            iconColor: primaryCrimson,
                            iconBg: const Color(0xFFFFDAD4),
                            title: 'Mobile Push Notifications',
                            subtitle: 'Daily recommended vacancies & pipeline updates',
                            note: null,
                            value: _pushAlerts,
                            onChanged: (v) => setState(() => _pushAlerts = v),
                          ),
                          const SizedBox(height: 8),
                          _buildChannelTile(
                            icon: Icons.forward_to_inbox,
                            iconColor: const Color(0xFF42474F),
                            iconBg: const Color(0xFFDEE2ED),
                            title: 'Recruiter Search Digest',
                            subtitle: 'Weekly email summary of corporate profile views',
                            note: null,
                            value: _emailDigest,
                            onChanged: (v) => setState(() => _emailDigest = v),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: cardHigh, borderRadius: BorderRadius.circular(6)),
                            child: const Row(
                              children: [
                                Icon(Icons.schedule, size: 14, color: primaryCrimson),
                                SizedBox(width: 6),
                                Text(
                                  'Batch window: Daily at 8:00 PM AST • Instant SMS for shortlists.',
                                  style: TextStyle(fontSize: 9, color: textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Regional Localization
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.language, size: 18, color: primaryCrimson),
                              SizedBox(width: 8),
                              Text('Regional Localization', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('PLATFORM LANGUAGE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _selectedLanguage = 'en'),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _selectedLanguage == 'en' ? primaryCrimson : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'English (GCC Standard)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedLanguage == 'en' ? Colors.white : textOnSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => setState(() => _selectedLanguage = 'ar'),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _selectedLanguage == 'ar' ? primaryCrimson : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'العربية (KSA & الخليج)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedLanguage == 'ar' ? Colors.white : textOnSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('COMPENSATION UNIT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('SAR (Saudi Riyal)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                                          Icon(Icons.expand_more, size: 16, color: textSecondary),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('TIME REFERENCE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('AST (UTC+3)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                                          Icon(Icons.schedule, size: 16, color: textSecondary),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Privacy & GCC Compliance
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.security, size: 18, color: primaryCrimson),
                              SizedBox(width: 8),
                              Text('Privacy & GCC Compliance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Strict protection under Saudi NDMO & UAE Federal Data Protection standards.',
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Visibility Guard', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(4)),
                                      child: const Text('Verified Sponsors Only', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primaryCrimson)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Unverified recruiters and generic search engine crawlers cannot view contact details or full CV attachments.',
                                  style: TextStyle(fontSize: 10, color: textSecondary),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(color: cardHigh, borderRadius: BorderRadius.circular(6)),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.block, size: 16, color: Color(0xFFBA1A1A)),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('HIDDEN FROM CURRENT EMPLOYER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textSecondary)),
                                            Text('PetroGulf Energy Ltd.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                                          ],
                                        ),
                                      ),
                                      Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: cardLow, borderRadius: BorderRadius.circular(8)),
                            child: const Row(
                              children: [
                                Icon(Icons.lock_clock, size: 18, color: primaryCrimson),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('256-bit AES Vault Encryption', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                                      Text(
                                        'All attested educational degrees, medical certificates, and police clearances are safeguarded with sovereign tier isolation.',
                                        style: TextStyle(fontSize: 9, color: textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.download, size: 16, color: primaryCrimson),
                              label: const Text('Download Complete Dossier (PDF • JSON)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textOnSurface)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cardHigh,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Request Permanent Profile Erasure', style: TextStyle(fontSize: 11, color: Color(0xFFBA1A1A))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dedicated Mobility Advisor Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFFFF1F1),
                                child: Icon(Icons.support_agent, size: 22, color: primaryCrimson),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('DEDICATED MOBILITY ADVISOR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondary)),
                                    Text('Eng. Tariq Al-Ghamdi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textOnSurface)),
                                  ],
                                ),
                              ),
                              Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF25D366))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Assigned to guide your embassy trade tests, medical staging, and final Saudi visa endorsements.',
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final uri = Uri.parse('https://wa.me/966550123456?text=Hello%20Eng.%20Tariq,%20I%20need%20assistance%20with%20my%20GCC%20mobility%20process');
                                try {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                } catch (_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Advisor WhatsApp: +966 55 012 3456')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.send, size: 16, color: Colors.white),
                              label: const Text('Message Advisor via WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryCrimson,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sign Out & Version Info
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                              content: const Text('Are you sure you want to sign out of the GCC Recruitment Portal?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA1A1A), foregroundColor: Colors.white),
                                  onPressed: () async {
                                    Navigator.pop(ctx);
                                    await ref.read(authStateProvider.notifier).logout();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✓ Signed out successfully. You can sign in anytime.'),
                                          backgroundColor: Color(0xFF059669),
                                        ),
                                      );
                                        context.go(RouteNames.login);
                                      }
                                    },
                                    child: const Text('Sign Out'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, size: 18, color: Color(0xFFBA1A1A)),
                        label: const Text('Sign Out of GCC Portal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFBA1A1A))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFFDAD6)),
                          backgroundColor: cardLow,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Column(
                        children: [
                          Text('Global Jobs by Suhana • v2.4.1 (Build 890)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF42474F))),
                          SizedBox(height: 2),
                          Text('Certified Overseas Manpower License #OM-9823/GCC', style: TextStyle(fontSize: 9, color: textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryToggle(String flag, String country, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(country, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF181C23))),
                Text(subtitle, style: TextStyle(fontSize: 10, color: value ? const Color(0xFF6E0000) : const Color(0xFF5A5F67), fontWeight: value ? FontWeight.w600 : FontWeight.normal)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF6E0000),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildChannelTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String? note,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF181C23))),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF5A5F67))),
                if (note != null) ...[
                  const SizedBox(height: 2),
                  Text(note, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF6E0000))),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF6E0000),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';
import 'package:mena_recruitment/core/widgets/notifications_sheet.dart';
import 'package:mena_recruitment/features/auth/presentation/auth_sheet.dart';
import 'package:mena_recruitment/features/auth/providers/auth_provider.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';
import 'package:mena_recruitment/features/cv_parser/presentation/widgets/cv_preview_modal.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // ── Privacy state ──────────────────────────────────────────────────────────
  String _visibilityMode = 'sponsors_only'; // 'sponsors_only' | 'all_recruiters' | 'private'
  String _hiddenFromCompany = 'PetroGulf Energy Ltd.';

  // ── Region filter ──────────────────────────────────────────────────────────
  String _selectedRegion = 'GCC';

  static const _regions = [
    'GCC',
    'Levant & N. Africa',
    'Europe',
    'North America',
    'Australia & Pacific',
    'South & SE Asia',
  ];

  static const _regionCountries = {
    'GCC': [
      {'flag': '🇸🇦', 'name': 'Saudi Arabia', 'subtitle': 'Eligible for Qiwa · Muqeem'},
      {'flag': '🇦🇪', 'name': 'UAE', 'subtitle': 'MOHRE Green Visa open'},
      {'flag': '🇶🇦', 'name': 'Qatar', 'subtitle': 'QatarEnergy visa pool'},
      {'flag': '🇰🇼', 'name': 'Kuwait', 'subtitle': 'MOI work permit available'},
      {'flag': '🇴🇲', 'name': 'Oman', 'subtitle': 'Manpower Ministry portal'},
      {'flag': '🇧🇭', 'name': 'Bahrain', 'subtitle': 'LMRA flexi-permit'},
    ],
    'Levant & N. Africa': [
      {'flag': '🇪🇬', 'name': 'Egypt', 'subtitle': 'Oil sector contracts (Cairo)'},
      {'flag': '🇯🇴', 'name': 'Jordan', 'subtitle': 'ASEZA free zone hiring'},
      {'flag': '🇱🇧', 'name': 'Lebanon', 'subtitle': 'Offshore E&P roles'},
      {'flag': '🇲🇦', 'name': 'Morocco', 'subtitle': 'Tangier Med industrial zone'},
      {'flag': '🇹🇳', 'name': 'Tunisia', 'subtitle': 'Energy & mining sector'},
      {'flag': '🇩🇿', 'name': 'Algeria', 'subtitle': 'Sonatrach project sites'},
    ],
    'Europe': [
      {'flag': '🇬🇧', 'name': 'United Kingdom', 'subtitle': 'North Sea · Skilled Worker visa'},
      {'flag': '🇩🇪', 'name': 'Germany', 'subtitle': 'Skilled immigration act'},
      {'flag': '🇫🇷', 'name': 'France', 'subtitle': 'Total Energies · Talent permit'},
      {'flag': '🇳🇱', 'name': 'Netherlands', 'subtitle': 'Rotterdam energy hub'},
      {'flag': '🇳🇴', 'name': 'Norway', 'subtitle': 'North Sea O&G sector'},
      {'flag': '🇮🇪', 'name': 'Ireland', 'subtitle': 'Critical Skills permit'},
    ],
    'North America': [
      {'flag': '🇺🇸', 'name': 'United States', 'subtitle': 'H-1B / TN visa eligible'},
      {'flag': '🇨🇦', 'name': 'Canada', 'subtitle': 'Express Entry · Alberta O&G'},
    ],
    'Australia & Pacific': [
      {'flag': '🇦🇺', 'name': 'Australia', 'subtitle': 'TSS 482 · FIFO mining & LNG'},
      {'flag': '🇳🇿', 'name': 'New Zealand', 'subtitle': 'Accredited employer visa'},
      {'flag': '🇵🇬', 'name': 'Papua New Guinea', 'subtitle': 'LNG project sites'},
    ],
    'South & SE Asia': [
      {'flag': '🇮🇳', 'name': 'India', 'subtitle': 'ONGC & Reliance upstream'},
      {'flag': '🇵🇰', 'name': 'Pakistan', 'subtitle': 'Offshore Makran projects'},
      {'flag': '🇸🇬', 'name': 'Singapore', 'subtitle': 'EP · Marine & offshore'},
      {'flag': '🇲🇾', 'name': 'Malaysia', 'subtitle': 'Petronas · EP holder'},
      {'flag': '🇮🇩', 'name': 'Indonesia', 'subtitle': 'IMTA work permit'},
    ],
  };

  // country toggle state — keyed by country name
  final Map<String, bool> _countryToggles = {
    'Saudi Arabia': true,
    'UAE': true,
    'Qatar': true,
    'Kuwait': false,
    'Oman': false,
    'Bahrain': false,
  };

  // Notification preferences
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...options.map((opt) {
                final isSelected = _relocationTimeline == opt;
                return InkWell(
                  onTap: () {
                    setState(() => _relocationTimeline = opt);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Relocation timeline updated to: $opt'),
                        backgroundColor: const Color(0xFF059669),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF1F1) : const Color(0xFFF1F3FD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? _crimson : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 16,
                          color: isSelected ? _crimson : _inkLight,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? _crimson : _ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              const Text('Or enter custom timeline:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _inkLight)),
              const SizedBox(height: 4),
              TextField(
                controller: customCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. 45 days, Negotiable',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (customCtrl.text.trim().isNotEmpty) {
                setState(() => _relocationTimeline = customCtrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Relocation timeline updated to: ${customCtrl.text.trim()}'),
                    backgroundColor: const Color(0xFF059669),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _crimson, foregroundColor: Colors.white),
            child: const Text('Save Custom'),
          ),
        ],
      ),
    );
  }

  void _editMinSalary() {
    final presets = [
      'SAR 10,000 / mo',
      'SAR 12,500 / mo',
      'SAR 15,000 / mo',
      'SAR 18,000 / mo',
      'SAR 20,000 / mo',
      'SAR 25,000+ / mo',
    ];
    final salaryCtrl = TextEditingController(text: _minSalary);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Minimum Expected Salary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter target minimum monthly pay:', style: TextStyle(fontSize: 11, color: _inkLight)),
              const SizedBox(height: 6),
              TextField(
                controller: salaryCtrl,
                decoration: const InputDecoration(
                  labelText: 'Minimum Salary',
                  hintText: 'e.g. SAR 15,000 / mo',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              const Text('Or select standard tier:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _inkLight)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: presets.map((p) {
                  return ActionChip(
                    label: Text(p, style: const TextStyle(fontSize: 11)),
                    backgroundColor: _minSalary == p ? const Color(0xFFFFF1F1) : const Color(0xFFF1F3FD),
                    side: BorderSide(color: _minSalary == p ? _crimson : Colors.transparent),
                    onPressed: () {
                      salaryCtrl.text = p;
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (salaryCtrl.text.trim().isNotEmpty) {
                setState(() => _minSalary = salaryCtrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Min. salary updated to: ${salaryCtrl.text.trim()}'),
                    backgroundColor: const Color(0xFF059669),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _crimson, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final authState = ref.watch(authStateProvider);
    final vaultDocsAsync = ref.watch(vaultDocumentsProvider);

    final profile = profileAsync.value;
    final currentUser = authState.user;
    final name = profile?.fullName ?? currentUser?.fullName ?? 'Ahmed Mansoor Al-Sayed';
    final title = profile?.targetTitle ?? 'Senior Offshore HSE Supervisor';
    final gccExp = profile?.gccExperience ?? 4;
    final uid = profile?.uid ?? currentUser?.id ?? 'SUH-GCC-88219';
    final score = (profile?.readinessScore ?? 85);
    final scoreFraction = score / 100.0;
    final docCount = vaultDocsAsync.value?.length ?? 4;

    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: _white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Profile',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _ink),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: _inkLight, size: 22),
                          onPressed: () => NotificationsSheet.show(context),
                        ),
                        InkWell(
                          onTap: () => AuthSheet.show(context),
                          borderRadius: BorderRadius.circular(16),
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: _cardMid,
                            child: Icon(Icons.person, size: 18, color: _crimson),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── 1. Profile Hero Card ─────────────────────────────
                  _Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Verification Ring
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: CircularProgressIndicator(
                                    value: scoreFraction,
                                    strokeWidth: 5,
                                    backgroundColor: _cardMid,
                                    valueColor: const AlwaysStoppedAnimation<Color>(_crimson),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$score%',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _crimson),
                                    ),
                                    const Text(
                                      'VERIFIED',
                                      style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: _inkLight, letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tier badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1F1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'TIER 1 CANDIDATE',
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _crimson, letterSpacing: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(title, style: const TextStyle(fontSize: 12, color: _inkLight)),
                                  const SizedBox(height: 2),
                                  Text('${gccExp.toStringAsFixed(1)} yrs GCC Experience',
                                      style: const TextStyle(fontSize: 12, color: _inkLight)),
                                  const SizedBox(height: 6),
                                  // UID + edit
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: _cardMid, borderRadius: BorderRadius.circular(4)),
                                        child: Text('#$uid',
                                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF42474F))),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => context.push(RouteNames.cvUpload),
                                        child: const Row(
                                          children: [
                                            Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson)),
                                            Icon(Icons.chevron_right, size: 14, color: _crimson),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── 2. Career KPI: GCC Job Match ─────────────────────────
                  _SectionHeader(
                    icon: Icons.corporate_fare_rounded,
                    title: 'GCC Job Match',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 12, color: _crimson),
                          SizedBox(width: 2),
                          Text('High Demand', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _crimson)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: 'You qualify for ',
                            style: TextStyle(fontSize: 13, color: _inkLight),
                            children: [
                              TextSpan(
                                text: '48 verified vacancies',
                                style: TextStyle(fontWeight: FontWeight.bold, color: _ink),
                              ),
                              TextSpan(text: ' across Saudi Arabia, UAE & Qatar.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('EST. TAX-FREE SALARY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                  SizedBox(height: 2),
                                  Text.rich(
                                    TextSpan(
                                      text: 'SAR 14,000 – 18,500',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _crimson),
                                      children: [
                                        TextSpan(text: ' / mo', style: TextStyle(fontSize: 12, color: _inkLight, fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text('+ Family status & furnished accommodation', style: TextStyle(fontSize: 10, color: _inkLight)),
                                ],
                              ),
                              Icon(Icons.trending_up_rounded, color: _crimson, size: 28),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── 3. My Documents (Vault merged in) ────────────────
                  _SectionHeader(
                    icon: Icons.folder_open_rounded,
                    title: 'My Documents',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: _cardMid, borderRadius: BorderRadius.circular(6)),
                      child: Text('${_hasCv ? docCount : docCount - 1} files',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _inkLight)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Card(
                    child: Column(
                      children: [
                        _DocTile(
                          icon: _hasCv ? Icons.description_rounded : Icons.upload_file_rounded,
                          title: 'CV / Resume',
                          subtitle: _hasCv ? _cvFileName : 'Not uploaded · Tap to upload',
                          status: _hasCv ? 'Verified' : 'Missing',
                          statusColor: _hasCv ? _crimson : const Color(0xFFBA1A1A),
                          onTap: () => context.push(RouteNames.cvUpload),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20, color: _inkLight),
                            padding: EdgeInsets.zero,
                            tooltip: 'CV Options',
                            onSelected: (action) {
                              if (action == 'preview') {
                                CvPreviewModal.show(
                                  context: context,
                                  fileName: _cvFileName,
                                  fileSize: '1.8 MB',
                                  isCustom: false,
                                  onReplaceCv: () => context.push(RouteNames.cvUpload),
                                );
                              } else if (action == 'review') {
                                context.push('/cv/review');
                              } else if (action == 'update') {
                                context.push('/cv/upload');
                              } else if (action == 'delete') {
                                _confirmDeleteCv();
                              }
                            },
                            itemBuilder: (ctx) => [
                              if (_hasCv) ...[
                                const PopupMenuItem(
                                  value: 'preview',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility_outlined, size: 18, color: _crimson),
                                      SizedBox(width: 8),
                                      Text('View CV Document', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _crimson)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'review',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_note_rounded, size: 18, color: _ink),
                                      SizedBox(width: 8),
                                      Text('Review & Edit Details', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Row(
                                    children: [
                                      Icon(Icons.cloud_upload_outlined, size: 18, color: _crimson),
                                      SizedBox(width: 8),
                                      Text('Update / Replace CV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _crimson)),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFBA1A1A)),
                                      SizedBox(width: 8),
                                      Text('Delete CV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFBA1A1A))),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                const PopupMenuItem(
                                  value: 'update',
                                  child: Row(
                                    children: [
                                      Icon(Icons.upload_file_rounded, size: 18, color: _crimson),
                                      SizedBox(width: 8),
                                      Text('Upload CV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _crimson)),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const _CardDivider(),
                        _DocTile(
                          icon: Icons.badge_rounded,
                          title: 'Passport',
                          subtitle: 'Exp: Jan 2028',
                          status: 'MRZ OK',
                          statusColor: _crimson,
                          onTap: () => context.push('/vault/passport-update'),
                        ),
                        const _CardDivider(),
                        _DocTile(
                          icon: Icons.military_tech_rounded,
                          title: 'Certifications',
                          subtitle: 'NEBOSH IGC, OPITO BOSIET',
                          status: '2 docs',
                          statusColor: _crimson,
                          onTap: () => context.push('/vault/certifications'),
                        ),
                        const _CardDivider(),
                        _DocTile(
                          icon: Icons.health_and_safety_rounded,
                          title: 'GAMCA Medical Clearance',
                          subtitle: 'Required for KSA visa',
                          status: 'Pending',
                          statusColor: const Color(0xFFB45309),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/vault/passport-scan'),
                            icon: const Icon(Icons.add, size: 16, color: _crimson),
                            label: const Text('Add Document', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _crimson)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: _crimson, width: 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── 4. Target Countries ──────────────────────────────
                  const _SectionHeader(icon: Icons.public_rounded, title: 'Target Countries'),
                  const SizedBox(height: 8),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Region filter chips
                        const Text('REGION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _regions.map((region) {
                              final isSelected = _selectedRegion == region;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedRegion = region),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected ? _crimson : _cardLow,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      region,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : _inkLight,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1, thickness: 0.5, color: _cardMid),
                        const SizedBox(height: 10),
                        // Dynamic countries for selected region
                        ...(_regionCountries[_selectedRegion] ?? []).map((country) {
                          final name = country['name']!;
                          final enabled = _countryToggles[name] ?? false;
                          return _CountryToggle(
                            country['flag']!,
                            name,
                            country['subtitle']!,
                            enabled,
                            (v) => setState(() => _countryToggles[name] = v),
                          );
                        }),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _editRelocationTimeline,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _cardLow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('RELOCATION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                            const SizedBox(height: 2),
                                            Text(_relocationTimeline, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.edit_outlined, size: 14, color: _crimson),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: _editMinSalary,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _cardLow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('MIN. SALARY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                            const SizedBox(height: 2),
                                            Text(_minSalary, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.edit_outlined, size: 14, color: _crimson),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── 5. Privacy & Security ───────────────────────────
                  const _SectionHeader(icon: Icons.shield_outlined, title: 'Privacy & Security'),
                  const SizedBox(height: 8),
                  _Card(
                    child: Column(
                      children: [
                        // Profile Visibility row — tappable
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Profile Visibility', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _VisibilityOption(
                                      icon: Icons.verified_user_outlined,
                                      label: 'Verified Sponsors Only',
                                      subtitle: 'Only MOHRE/GAMCA-verified employers see you',
                                      value: 'sponsors_only',
                                      selected: _visibilityMode,
                                      onTap: () { setState(() => _visibilityMode = 'sponsors_only'); Navigator.pop(ctx); },
                                    ),
                                    const SizedBox(height: 8),
                                    _VisibilityOption(
                                      icon: Icons.public,
                                      label: 'All Recruiters',
                                      subtitle: 'Any registered recruiter can view your profile',
                                      value: 'all_recruiters',
                                      selected: _visibilityMode,
                                      onTap: () { setState(() => _visibilityMode = 'all_recruiters'); Navigator.pop(ctx); },
                                    ),
                                    const SizedBox(height: 8),
                                    _VisibilityOption(
                                      icon: Icons.lock_outline,
                                      label: 'Private',
                                      subtitle: 'Profile hidden — apply directly to jobs only',
                                      value: 'private',
                                      selected: _visibilityMode,
                                      onTap: () { setState(() => _visibilityMode = 'private'); Navigator.pop(ctx); },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                ],
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Profile Visibility', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _ink)),
                                    const SizedBox(height: 2),
                                    Text(
                                      _visibilityMode == 'sponsors_only'
                                          ? 'Verified sponsors only'
                                          : _visibilityMode == 'all_recruiters'
                                              ? 'All recruiters'
                                              : 'Private (hidden)',
                                      style: const TextStyle(fontSize: 11, color: _inkLight),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _visibilityMode == 'private'
                                            ? const Color(0xFFF1F3FD)
                                            : const Color(0xFFFFF1F1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _visibilityMode == 'private' ? 'Private' : 'Active',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _visibilityMode == 'private' ? _inkLight : _crimson,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right, size: 16, color: _inkLight),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Hidden from company — tappable Edit
                        GestureDetector(
                          onTap: () {
                            final ctrl = TextEditingController(text: _hiddenFromCompany);
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Hide Profile From', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                content: TextField(
                                  controller: ctrl,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Company name',
                                    hintText: 'e.g. Aramco, Shell, TotalEnergies',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (ctrl.text.trim().isNotEmpty) {
                                        setState(() => _hiddenFromCompany = ctrl.text.trim());
                                      }
                                      Navigator.pop(ctx);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _crimson,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.block, size: 16, color: Color(0xFFBA1A1A)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('HIDDEN FROM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                      Text(_hiddenFromCompany, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                                    ],
                                  ),
                                ),
                                const Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _crimson)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('⬇ Generating your GCC Candidate Dossier…'),
                                  backgroundColor: Color(0xFF334155),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.download_rounded, size: 16, color: _crimson),
                            label: const Text('Download My Dossier (PDF)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _ink)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _cardMid,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── 6. Notifications ─────────────────────────────────
                  const _SectionHeader(icon: Icons.notifications_outlined, title: 'Notifications'),
                  const SizedBox(height: 8),
                  _Card(
                    child: Column(
                      children: [
                        _NotifToggle(
                          icon: Icons.chat_bubble_rounded,
                          iconColor: const Color(0xFF128C7E),
                          label: 'WhatsApp',
                          subtitle: 'Interview invites & embassy updates',
                          value: _whatsappAlerts,
                          onChanged: (v) => setState(() => _whatsappAlerts = v),
                        ),
                        const _CardDivider(),
                        _NotifToggle(
                          icon: Icons.phone_android_rounded,
                          iconColor: _crimson,
                          label: 'Push Notifications',
                          subtitle: 'New jobs & pipeline updates',
                          value: _pushAlerts,
                          onChanged: (v) => setState(() => _pushAlerts = v),
                        ),
                        const _CardDivider(),
                        _NotifToggle(
                          icon: Icons.forward_to_inbox_rounded,
                          iconColor: _inkLight,
                          label: 'Email Digest',
                          subtitle: 'Weekly profile view summary',
                          value: _emailDigest,
                          onChanged: (v) => setState(() => _emailDigest = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),


                  // ── 7. Language & Region ─────────────────────────────
                  const _SectionHeader(icon: Icons.language_rounded, title: 'Language & Region'),
                  const SizedBox(height: 8),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('PLATFORM LANGUAGE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              _LangTab('English', 'en', _selectedLanguage, () => setState(() => _selectedLanguage = 'en')),
                              _LangTab('العربية', 'ar', _selectedLanguage, () => setState(() => _selectedLanguage = 'ar')),
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
                                  const Text('CURRENCY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('SAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                                        Icon(Icons.expand_more, size: 16, color: _inkLight),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('TIMEZONE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(color: _cardLow, borderRadius: BorderRadius.circular(8)),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('AST +3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _ink)),
                                        Icon(Icons.schedule, size: 16, color: _inkLight),
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
                  const SizedBox(height: 14),

                  // ── 8. Mobility Advisor ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _cardMid,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: _white,
                              child: Icon(Icons.support_agent_rounded, size: 22, color: _crimson),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('YOUR CAREER ADVISOR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _inkLight)),
                                  Text('Eng. Tariq Al-Ghamdi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _ink)),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF25D366)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Get fast-track visa guidance, embassy clearance, and GCC relocation support.',
                          style: TextStyle(fontSize: 11, color: _inkLight),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => WhatsAppService.showWhatsAppAssistantSheet(
                              context: context,
                              title: 'Career Advisor — Tariq',
                              referenceCode: 'ADVISOR-TARIQ-GCC',
                            ),
                            icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
                            label: const Text('Chat on WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _crimson,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Sign out ─────────────────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Sign Out', style: TextStyle(fontSize: 12, color: Color(0xFFBA1A1A))),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable small widgets ───────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  const _SectionHeader({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6E0000)),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF181C23))),
        const Spacer(),
        ?trailing,
      ],
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 16, thickness: 0.5, color: Color(0xFFE5E8F2));
}

class _DocTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _DocTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.onTap,
    this.trailing,
  });

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF1F3FD), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 18, color: const Color(0xFF6E0000)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF181C23))),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF5A5F67)), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
            ),
            const SizedBox(width: 4),
            trailing ?? const Icon(Icons.chevron_right, size: 18, color: Color(0xFF5A5F67)),
          ],
        ),
      ),
    );
  }
}

class _CountryToggle extends StatelessWidget {
  final String flag;
  final String country;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CountryToggle(this.flag, this.country, this.subtitle, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(country, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF181C23))),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF5A5F67))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF6E0000),
            activeTrackColor: const Color(0xFF6E0000).withValues(alpha: 0.4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _NotifToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifToggle({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF181C23))),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF5A5F67))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF6E0000),
            activeTrackColor: const Color(0xFF6E0000).withValues(alpha: 0.4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _LangTab extends StatelessWidget {
  final String label;
  final String code;
  final String selected;
  final VoidCallback onTap;

  const _LangTab(this.label, this.code, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == code;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6E0000) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF181C23),
            ),
          ),
        ),
      ),
    );
  }
}

class _VisibilityOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _VisibilityOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF1F1) : const Color(0xFFF1F3FD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF6E0000) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? const Color(0xFF6E0000) : const Color(0xFF5A5F67)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF6E0000) : const Color(0xFF181C23))),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF5A5F67))),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, size: 18, color: Color(0xFF6E0000)),
          ],
        ),
      ),
    );
  }
}

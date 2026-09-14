import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';

/// Pre-step chooser shown when the user taps "Edit" in their profile.
/// NOT labelled as Step 1 — steps begin only after an entry method is chosen.
class ProfileEntryOptionsScreen extends StatelessWidget {
  const ProfileEntryOptionsScreen({super.key});

  // theme palette (matches settings_screen.dart)
  static const _crimson = Color(0xFF6E0000);
  static const _crimsonLight = Color(0xFFF4E6E6);
  static const _surface = Color(0xFFF9F9FF);
  static const _ink = Color(0xFF181C23);
  static const _inkLight = Color(0xFF5A5F67);
  static const _cardBg = Colors.white;
  static const _linkedInBlue = Color(0xFF0A66C2);
  static const _manualGreen = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              _BackButton(),
              const SizedBox(height: 20),

              // Suhana brand badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_outlined, size: 12, color: Color(0xFF334155)),
                    SizedBox(width: 5),
                    Text(
                      'GLOBAL JOBS BY SUHANA • GCC DIRECT RELOCATION',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Page title
              const Text(
                'Build Your Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: _ink),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose how you\'d like to set up your profile. You can always update it later.',
                style: TextStyle(fontSize: 13, color: _inkLight, height: 1.5),
              ),
              const SizedBox(height: 28),

              // Option 1: AI Resume Parser (primary / highlighted)
              _OptionCard(
                icon: Icons.auto_awesome_rounded,
                iconBg: _crimsonLight,
                iconColor: _crimson,
                badge: 'RECOMMENDED',
                badgeColor: _crimson,
                title: 'AI Resume Parser',
                subtitle:
                    'Upload your CV and our AI extracts your experience, skills, and certifications automatically — done in seconds.',
                accentColor: _crimson,
                isPrimary: true,
                onTap: () => context.push(RouteNames.cvUpload),
              ),
              const SizedBox(height: 14),

              // Option 2: Import from LinkedIn
              _OptionCard(
                icon: Icons.link_rounded,
                iconBg: const Color(0xFFE8F0FB),
                iconColor: _linkedInBlue,
                badge: 'QUICK IMPORT',
                badgeColor: _linkedInBlue,
                title: 'Import from LinkedIn',
                subtitle:
                    'Connect your LinkedIn profile and we\'ll auto-fill your work history, education, and skills instantly.',
                accentColor: _linkedInBlue,
                isPrimary: false,
                onTap: () => _showLinkedInModal(context),
              ),
              const SizedBox(height: 14),

              // Option 3: Enter Manually
              _OptionCard(
                icon: Icons.edit_note_rounded,
                iconBg: const Color(0xFFD1FAE5),
                iconColor: _manualGreen,
                badge: 'MANUAL',
                badgeColor: _manualGreen,
                title: 'Enter Manually',
                subtitle:
                    'Prefer to type it in yourself? Fill out each section at your own pace — personal, work, education, and more.',
                accentColor: _manualGreen,
                isPrimary: false,
                onTap: () => context.push(RouteNames.cvManualDetails),
              ),
              const SizedBox(height: 32),

              // Footer privacy note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _crimsonLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 16, color: _crimson),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your information is encrypted and only shared with employers you apply to. We never sell your data.',
                        style: TextStyle(fontSize: 11, color: _crimson, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLinkedInModal(BuildContext context) {
    final controller = TextEditingController(text: 'https://linkedin.com/in/');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.link, color: _linkedInBlue),
            SizedBox(width: 8),
            Text('Import from LinkedIn',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paste your public LinkedIn profile URL below.',
                style: TextStyle(fontSize: 13, color: _inkLight)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'https://linkedin.com/in/your-name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            const Text(
              'Make sure your LinkedIn profile is set to Public before importing.',
              style: TextStyle(fontSize: 11, color: _inkLight),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: _inkLight)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Import'),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('LinkedIn profile imported and parsed!'),
                  backgroundColor: _linkedInBlue,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _linkedInBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Back Button
// ─────────────────────────────────────────────────────────────────────────────
class _BackButton extends StatefulWidget {
  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.profile);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered
                ? ProfileEntryOptionsScreen._crimson
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back,
            size: 18,
            color: _hovered ? Colors.white : const Color(0xFF1E1B1B),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Option Card
// ─────────────────────────────────────────────────────────────────────────────
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.isPrimary,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String badge;
  final Color badgeColor;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ProfileEntryOptionsScreen._cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? accentColor.withAlpha(102)
                : const Color(0xFFE8EAF0),
            width: isPrimary ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? accentColor.withAlpha(20)
                  : Colors.black.withAlpha(8),
              blurRadius: isPrimary ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: ProfileEntryOptionsScreen._ink,
                          ),
                        ),
                      ),
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: badgeColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ProfileEntryOptionsScreen._inkLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // "Get Started →"
                  Row(
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded,
                          size: 14, color: accentColor),
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
}

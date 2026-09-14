import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';
import 'package:mena_recruitment/features/cv_parser/providers/manual_profile_state.dart';
import 'package:mena_recruitment/features/jobs/providers/regional_vacancies_provider.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:mena_recruitment/features/vault/domain/vault_document_entity.dart';
import 'package:mena_recruitment/features/vault/providers/vault_provider.dart';

class VaultScreen extends ConsumerWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final vaultDocsAsync = ref.watch(vaultDocumentsProvider);
    final candidate = profileAsync.valueOrNull;
    final readinessScore = candidate?.readinessScore ?? 0;
    final candidateName = candidate != null && candidate.fullName.isNotEmpty
        ? candidate.fullName
        : 'Candidate Profile';
    final candidateHeadline = candidate != null && candidate.targetTitle.isNotEmpty
        ? candidate.targetTitle
        : 'Complete your profile';
    final candidateExp = candidate?.gccExperience ?? 0;
    final manualProfile = ref.watch(manualProfileProvider);
    final resumeFileName = manualProfile.salaryRelocation.resumeFileName;
    final hasCv = resumeFileName != null && resumeFileName.isNotEmpty;
    final cvName = hasCv ? resumeFileName : 'Resume_Document.pdf';

    final vaultDocs = vaultDocsAsync.valueOrNull ?? [];
    final passportDoc = vaultDocs.where((d) => d.category == DocumentCategory.passport).firstOrNull;
    final hasPassport = passportDoc != null && passportDoc.documentNumber.isNotEmpty;

    final manualCerts = manualProfile.certifications;
    final vaultTradeCerts = vaultDocs.where((d) => d.category == DocumentCategory.tradeLicense || d.category == DocumentCategory.educationAttestation).toList();
    final List<String> allCerts = [];
    for (final c in manualCerts) {
      if (c.title.isNotEmpty && !allCerts.contains(c.title)) allCerts.add(c.title);
    }
    for (final v in vaultTradeCerts) {
      if (v.title.isNotEmpty && !allCerts.contains(v.title)) allCerts.add(v.title);
    }
    final hasCerts = allCerts.isNotEmpty;

    final statsAsync = ref.watch(activeRegionVacanciesStatsProvider);
    final stats = statsAsync.valueOrNull;
    final vacanciesCount = stats?.totalVacancies ?? 8;
    final countriesSummary = stats?.countriesSummary ?? 'Saudi Arabia, UAE & Qatar';
    final salaryRange = stats?.formattedSalaryRange ?? 'SAR 14,000 – 18,500';
    final regionLabel = stats?.regionLabel ?? 'GCC';

    const primaryCrimson = Color(0xFF6E0000);
    const containerCrimson = Color(0xFF990000);
    const lightSurface = Color(0xFFF9F9FF);
    const cardLowest = Colors.white;
    const cardLow = Color(0xFFF1F3FD);
    const cardHigh = Color(0xFFE5E8F2);
    const textOnSurface = Color(0xFF181C23);
    const textSecondary = Color(0xFF5A5F67);

    return Scaffold(
      backgroundColor: lightSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Header
              Container(
                color: cardLowest,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.task_alt, size: 14, color: primaryCrimson),
                            SizedBox(width: 4),
                            Text(
                              'STEP 4 OF 4: PROFILE READY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: primaryCrimson,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '100% Complete',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 1.0,
                        minHeight: 5,
                        backgroundColor: cardHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(containerCrimson),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Profile Setup Complete!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textOnSurface,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        text: 'Your profile meets ',
                        style: const TextStyle(fontSize: 13, color: textSecondary),
                        children: [
                          TextSpan(
                            text: '$readinessScore%',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: primaryCrimson),
                          ),
                          const TextSpan(text: ' of Gulf employer screening requirements.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // 1. Profile Strength Hero Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Verified Radial Dial
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: CircularProgressIndicator(
                                      value: readinessScore / 100.0,
                                      strokeWidth: 6,
                                      backgroundColor: cardHigh,
                                      valueColor: const AlwaysStoppedAnimation<Color>(primaryCrimson),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$readinessScore%',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: primaryCrimson,
                                        ),
                                      ),
                                      const Text(
                                        'VERIFIED',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                          color: textSecondary,
                                          letterSpacing: 0.5,
                                        ),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDFE2EC),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'TIER 1 CANDIDATE',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                          color: Color(0xFF5B403C),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      candidateName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textOnSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Icon(Icons.engineering, size: 14, color: primaryCrimson),
                                        const SizedBox(width: 4),
                                        Text(candidateHeadline, style: const TextStyle(fontSize: 11, color: textSecondary)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.history_toggle_off, size: 14, color: primaryCrimson),
                                        const SizedBox(width: 4),
                                        Text('${candidateExp.toStringAsFixed(1)} yrs GCC Experience', style: const TextStyle(fontSize: 11, color: textSecondary)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Badges Row
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cardLow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _PillBadge(icon: Icons.verified, label: 'MRZ PASSPORT OK'),
                                _PillBadge(icon: Icons.document_scanner, label: 'CV PARSED'),
                                _PillBadge(icon: Icons.workspace_premium, label: 'NEBOSH VERIFIED'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 2. Employer Matching Preview
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDAD4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.corporate_fare, color: primaryCrimson, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$regionLabel Employer Match',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: textOnSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text.rich(
                                      TextSpan(
                                        text: 'You qualify for ',
                                        style: const TextStyle(fontSize: 12, color: textSecondary),
                                        children: [
                                          TextSpan(
                                            text: '$vacanciesCount High-Priority Vacancies',
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: textOnSurface),
                                          ),
                                          TextSpan(text: ' across $countriesSummary.'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardLow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ESTIMATED TAX-FREE SALARY RANGE',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    text: '$salaryRange ',
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: primaryCrimson),
                                    children: const [
                                      TextSpan(
                                        text: '/ mo',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Row(
                                  children: [
                                    Icon(Icons.apartment, size: 14, color: primaryCrimson),
                                    SizedBox(width: 4),
                                    Text(
                                      '+ Family Status / Free Furnished Accommodation Included',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textOnSurface),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 3. Document Vault Inventory
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardLowest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.folder_shared, size: 18, color: primaryCrimson),
                                  SizedBox(width: 8),
                                  Text(
                                    'Document Vault Inventory',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: cardHigh,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${vaultDocsAsync.value?.length ?? 4} Assets',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondary),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Asset 1: CV Document
                          _buildAssetItem(
                            icon: hasCv ? Icons.description : Icons.upload_file,
                            title: hasCv ? cvName : 'CV / Resume',
                            subtitle: hasCv ? 'Parsed & Active' : 'Not uploaded · Tap to parse',
                            statusColor: hasCv ? primaryCrimson : textSecondary,
                            onTap: () {
                              if (hasCv) {
                                ref.read(manualProfileProvider.notifier).setStage(0);
                                context.push(RouteNames.cvManualDetails);
                              } else {
                                context.push(RouteNames.cvUpload);
                              }
                            },
                            buttonText: hasCv ? 'View' : 'Upload',
                          ),
                          const SizedBox(height: 8),

                          // Asset 2: Passport Bio-Page
                          _buildAssetItem(
                            icon: Icons.badge,
                            title: hasPassport ? 'Passport_${passportDoc.documentNumber}.jpg' : 'Passport Bio-Page',
                            subtitle: hasPassport
                                ? (passportDoc.expiryDate != null ? 'MRZ Validated • Exp ${passportDoc.expiryDate!.year}' : 'MRZ Validated')
                                : 'Not uploaded · Tap to add',
                            statusColor: hasPassport ? primaryCrimson : textSecondary,
                            onTap: () => context.push('/vault/passport-update'),
                            buttonText: hasPassport ? 'View' : 'Upload',
                          ),
                          const SizedBox(height: 8),

                          // Asset 3: Safety Certificates
                          _buildAssetItem(
                            icon: Icons.military_tech,
                            title: hasCerts ? allCerts.join(', ') : 'Safety & Trade Certificates',
                            subtitle: hasCerts ? '${allCerts.length} Certified GCC Credential${allCerts.length > 1 ? 's' : ''}' : 'Not uploaded · Tap to add',
                            statusColor: hasCerts ? primaryCrimson : textSecondary,
                            onTap: () => context.push('/vault/certifications'),
                            buttonText: hasCerts ? 'View' : 'Add',
                          ),
                          const SizedBox(height: 8),

                          // Asset 4: GAMCA Clearance
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardLow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: cardHigh, borderRadius: BorderRadius.circular(6)),
                                  child: const Icon(Icons.health_and_safety, size: 18, color: textSecondary),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'GAMCA Fitness Clearance',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                                      ),
                                      Text(
                                        'Status: Pending Center Slot',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF5B403C)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDAD4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Book',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryCrimson),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 4. Dedicated Mobility Advisor Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardHigh,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cardLowest,
                                ),
                                child: const Icon(Icons.support_agent, size: 24, color: primaryCrimson),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ASSIGNED SUHANA CAREER ADVISOR',
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: textSecondary),
                                    ),
                                    Text(
                                      'Eng. Tariq Al-Ghamdi',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textOnSurface),
                                    ),
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
                            'Need fast-track visa sponsorship guidance or embassy clearance answers?',
                            style: TextStyle(fontSize: 11, color: textSecondary),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              WhatsAppService.showWhatsAppAssistantSheet(
                                context: context,
                                title: 'Direct Mobility Consultation',
                                referenceCode: 'ADVISOR-TARIQ-GCC',
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: cardLowest,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat, size: 16, color: primaryCrimson),
                                  SizedBox(width: 6),
                                  Text(
                                    'Chat on WhatsApp',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textOnSurface),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 5. Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/jobs'),
                        icon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                        label: const Text(
                          'Browse Matching Verified Jobs',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: containerCrimson,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: TextButton.icon(
                        onPressed: () => context.go('/applications'),
                        icon: const Icon(Icons.timeline, size: 18, color: textSecondary),
                        label: const Text(
                          'View My Application Pipeline',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textOnSurface),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: cardHigh,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
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

  Widget _buildAssetItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color statusColor,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDFE2EC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6E0000)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF181C23)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF5A5F67)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E8F2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF181C23)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PillBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6E0000)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF181C23)),
          ),
        ],
      ),
    );
  }
}


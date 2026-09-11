import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';

class CvPreviewModal extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final bool isCustom;
  final VoidCallback? onReplaceCv;

  const CvPreviewModal({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.isCustom = false,
    this.onReplaceCv,
  });

  static void show({
    required BuildContext context,
    required String fileName,
    required String fileSize,
    bool isCustom = false,
    VoidCallback? onReplaceCv,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CvPreviewModal(
        fileName: fileName,
        fileSize: fileSize,
        isCustom: isCustom,
        onReplaceCv: onReplaceCv,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLatest = fileName.contains('2026') || !isCustom;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle & Top Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description, color: Color(0xFF059669), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Document Inspector',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E1B1B),
                              ),
                            ),
                            Text(
                              isLatest ? 'ACTIVE RECRUITER COPY (LATEST 2026)' : 'ATTACHED APPLICATION DOCUMENT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: isLatest ? const Color(0xFF059669) : const Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE4DADB)),

          // File Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1B1B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$fileSize • PDF Document • Parsed & Verified by Suhana AI',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLatest ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLatest ? Icons.check_circle_rounded : Icons.history_rounded,
                        size: 13,
                        color: isLatest ? const Color(0xFF065F46) : const Color(0xFF92400E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isLatest ? 'Latest Version' : 'Custom Attachment',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isLatest ? const Color(0xFF065F46) : const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Document Viewer Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Simulated High-Fidelity Paper Resume Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Resume Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF990000).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF990000).withValues(alpha: 0.2)),
                              ),
                              child: const Center(
                                child: Text(
                                  'AM',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF990000),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ahmed Mansoor Al-Farooq',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Senior Offshore HSE Supervisor & Technical Safety Lead',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF990000),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Dammam, KSA • +966 55 012 3456 • ahmed.mansoor@hse-mena.org',
                                    style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 10),

                        // Executive Summary
                        const Text(
                          'PROFESSIONAL SUMMARY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Accredited NEBOSH & Saudi Aramco approved HSE Specialist with 7+ years total experience (4+ years GCC offshore rigs & petrochemical turnarounds). Proven record maintaining zero LTI across 450+ multinational crews. Expert in Permit-to-Work (PTW) protocols, root-cause incident analyses, and GAMEP environmental compliance.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.4),
                        ),
                        const SizedBox(height: 14),

                        // Core Verified Competencies
                        const Text(
                          'VERIFIED COMPETENCIES & CREDENTIALS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildPill('NEBOSH IGC 1, 2, 3', true),
                            _buildPill('OPITO BOSIET + EBS', true),
                            _buildPill('Saudi Aramco SAP ID #88219', true),
                            _buildPill('PTW Level 3 Master', true),
                            _buildPill('H2S & Confined Space Rescue', false),
                            _buildPill('OSHA 30-Hour Construction', false),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Professional Experience Section
                        const Text(
                          'GCC WORK EXPERIENCE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 8),

                        _buildExperienceEntry(
                          role: 'Senior Offshore HSE Supervisor',
                          company: 'PetroGulf Energy Ltd. — Yanbu & Jubail, KSA',
                          duration: 'March 2021 – Present (3 yrs 8 mos)',
                          bulletPoints: [
                            'Direct safety supervision of jack-up drill rigs and offshore accommodation barges under Aramco guidelines.',
                            'Supervised scheduled plant turnaround HSE permits with zero recordable incidents.',
                            'Administered daily Tool Box Talks (TBT) and root cause analyses.',
                          ],
                        ),
                        const SizedBox(height: 10),

                        _buildExperienceEntry(
                          role: 'Offshore Safety Officer',
                          company: 'Consolidated Contractors Co. (CCC) — Ras Laffan, Qatar',
                          duration: 'June 2017 – February 2021 (3 yrs 9 mos)',
                          bulletPoints: [
                            'Conducted daily multi-gas testing in confined offshore chambers for QatarEnergy project sites.',
                            'Maintained HSE audit checklists and coordinated emergency drills.',
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Education & Attestation
                        const Text(
                          'EDUCATION & ATTESTATION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.school, size: 16, color: Color(0xFF64748B)),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'B.Sc. Mechanical Engineering — Cairo University (2016)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'MOFA ATTESTED',
                                style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF065F46)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Suhana Vault Match Callout
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_rounded, size: 20, color: Color(0xFF059669)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This CV is synchronized with your Suhana Digital Vault. Any updates made in profile or review will automatically reflect here.',
                            style: TextStyle(fontSize: 10.5, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE4DADB))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push(RouteNames.cvReview);
                    },
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Edit Extracted Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1E1B1B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onReplaceCv != null) {
                        onReplaceCv!();
                      } else {
                        context.push(RouteNames.cvUpload);
                      }
                    },
                    icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: const Text('Replace CV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPill(String label, bool isVerified) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isVerified ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isVerified ? const Color(0xFF93C5FD) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isVerified) ...[
            const Icon(Icons.check, size: 10, color: Color(0xFF1D4ED8)),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isVerified ? const Color(0xFF1E40AF) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildExperienceEntry({
    required String role,
    required String company,
    required String duration,
    required List<String> bulletPoints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                role,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              duration,
              style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          company,
          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF990000)),
        ),
        const SizedBox(height: 4),
        ...bulletPoints.map(
          (bp) => Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 10, color: Color(0xFF64748B), height: 1.3)),
                Expanded(
                  child: Text(
                    bp,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF334155), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

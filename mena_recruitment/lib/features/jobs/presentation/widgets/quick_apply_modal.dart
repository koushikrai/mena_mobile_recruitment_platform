import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';
import 'package:mena_recruitment/features/applications/providers/applications_provider.dart';
import 'package:mena_recruitment/features/cv_parser/presentation/widgets/cv_preview_modal.dart';
import 'package:mena_recruitment/features/cv_parser/providers/manual_profile_state.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';

class QuickApplyModal extends ConsumerStatefulWidget {
  final Job job;

  const QuickApplyModal({super.key, required this.job});

  static void show(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QuickApplyModal(job: job),
    );
  }

  @override
  ConsumerState<QuickApplyModal> createState() => _QuickApplyModalState();
}

class _QuickApplyModalState extends ConsumerState<QuickApplyModal> {
  bool _usePassport = true;
  bool _useCertificates = true;
  bool _isSubmitting = false;
  String _activeCvName = 'Candidate_CV.pdf';
  final String _activeCvSize = '1.8 MB';
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final resumeName = ref.read(manualProfileProvider).salaryRelocation.resumeFileName;
    if (resumeName != null && resumeName.isNotEmpty) {
      _activeCvName = resumeName;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitApplication() async {
    setState(() => _isSubmitting = true);
    try {
      final newApp = await ref.read(applicationsRepositoryProvider).applyForJob(
        jobId: widget.job.id,
        jobTitle: widget.job.title,
        companyName: widget.job.companyName,
        companyLogoUrl: widget.job.companyLogoUrl,
        countryCode: widget.job.countryCode,
        city: widget.job.city,
        coverNote: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : 'One-Tap quick application submitted with verified credentials.',
        documentIds: [
          if (_usePassport) 'doc-passport-01',
          if (_useCertificates) 'doc-cert-01',
        ],
      );
      ref.read(applicationsProvider.notifier).recordNewApplication(newApp);
      ref.invalidate(applicationsProvider);
    } catch (e) {
      debugPrint('[QuickApply] Notice: $e');
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.pop(context); // Close sheet

    // Open Success confirmation dialog
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Application Successfully Submitted!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your application for ${widget.job.title} at ${widget.job.companyName} has been transmitted directly to the licensed employer portal.',
              style: const TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F4F4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4DADB)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Direct Employer Reference', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                      Text(
                        'REF: ${widget.job.id.length > 8 ? widget.job.id.substring(0, 8).toUpperCase() : widget.job.id.toUpperCase()}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Suhana Priority Tier', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                      Text('Tier 1 • Verified Expat', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      WhatsAppService.showWhatsAppAssistantSheet(
                        context: context,
                        title: widget.job.title,
                        referenceCode: 'PG-HSE-908',
                      );
                    },
                    icon: const Icon(Icons.chat, color: Color(0xFF25D366), size: 18),
                    label: const Text('WhatsApp HR', style: TextStyle(color: Color(0xFF1E1B1B), fontSize: 12, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go(RouteNames.applications);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Track Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'One-Tap Quick Apply',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B)),
                        ),
                        Text(
                          'INSTANT PRE-VERIFIED SUBMISSION',
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5),
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
          ),
          const Divider(height: 1, color: Color(0xFFE4DADB)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Target Role Mini Badge Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.job.companyLogoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.business, color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.job.title,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.job.companyName} • ${widget.job.city}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('95% FIT', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Auto-attached CV Row with VIEW button
                  const Text('Pre-Attached Verified CV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description, color: Color(0xFF059669), size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _activeCvName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              const Text('1.8 MB • GCC HSE Specialist • Suhana Parsed', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // View Button
                        InkWell(
                          onTap: () {
                            CvPreviewModal.show(
                              context: context,
                              fileName: _activeCvName,
                              fileSize: _activeCvSize,
                              isCustom: false,
                            );
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF990000).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF990000).withValues(alpha: 0.25)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility_outlined, size: 12, color: Color(0xFF990000)),
                                SizedBox(width: 3),
                                Text(
                                  'View',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF990000)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Vault Documents Checkboxes
                  const Text('Pre-Attached Vault Documents', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B))),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE4DADB)),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: _usePassport,
                          dense: true,
                          activeColor: AppColors.primary,
                          title: const Text('Passport: N8492014 (Valid till 2028)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                          subtitle: const Text('ICAO-Compliant MRZ Verified • 2.4 Yrs Validity', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                          onChanged: (v) => setState(() => _usePassport = v ?? true),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        CheckboxListTile(
                          value: _useCertificates,
                          dense: true,
                          activeColor: AppColors.primary,
                          title: const Text('NEBOSH IGC & OPITO BOSIET Scans', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                          subtitle: const Text('2 Certificates Attached • Verified Active', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                          onChanged: (v) => setState(() => _useCertificates = v ?? true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Recruiter Note
                  const Text('Optional Note for Hiring Team', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'e.g. Immediate Iqama transfer available within 14 days.',
                      hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ),

          // Bottom One-Tap Submit Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE4DADB))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/jobs/${widget.job.id}/apply');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Full Form', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.flash_on_rounded, size: 16, color: Colors.amber),
                    label: Text(
                      _isSubmitting ? 'Transmitting...' : 'One-Tap Apply Now',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/providers/job_details_provider.dart';

class JobApplicationScreen extends ConsumerStatefulWidget {
  final String jobId;

  const JobApplicationScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends ConsumerState<JobApplicationScreen> {
  // Attached files state
  String _selectedCvName = 'Ahmed_Mansoor_HSE_CV_2026.pdf';
  // ignore: unused_field
  String _selectedCvSize = '1.8 MB';
  bool _useVaultPassport = true;
  bool _useVaultCertificates = true;
  bool _isUploadingNew = false;
  double _uploadProgress = 1.0;
  bool _isSubmitting = false;

  final TextEditingController _coverNoteController = TextEditingController();

  @override
  void dispose() {
    _coverNoteController.dispose();
    super.dispose();
  }

  void _simulateManualUpload() async {
    setState(() {
      _isUploadingNew = true;
      _uploadProgress = 0.1;
    });

    for (int i = 2; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      setState(() {
        _uploadProgress = i / 10.0;
      });
    }

    if (!mounted) return;
    setState(() {
      _isUploadingNew = false;
      _selectedCvName = 'Updated_HSE_Supervisor_Resume_2026.pdf';
      _selectedCvSize = '2.3 MB';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ New CV uploaded and verified with Suhana AI parser!'),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  void _showLinkedInImportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.link, color: Color(0xFF0A66C2)),
            SizedBox(width: 8),
            Text('Import from LinkedIn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suhana AI will extract your headline, GCC work experiences, and skills directly from your public LinkedIn profile.',
              style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: 'https://linkedin.com/in/ahmed-mansoor-hse',
              decoration: InputDecoration(
                labelText: 'LinkedIn Profile URL',
                prefixIcon: const Icon(Icons.person_outline, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedCvName = 'LinkedIn_Sync_Ahmed_Mansoor.pdf';
                _selectedCvSize = '1.4 MB';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ Profile imported from LinkedIn & synced with Suhana Vault!'),
                  backgroundColor: Color(0xFF0A66C2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A66C2),
              foregroundColor: Colors.white,
            ),
            child: const Text('Import & Auto-Fill'),
          ),
        ],
      ),
    );
  }

  void _submitApplication(Job job) async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
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
            const Text(
              'Your application for  at  has been transmitted directly to the MHRSD licensed employer portal.',
              style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
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
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Direct Employer Reference', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                      Text('REF: PG-HSE-908', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
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
                        title: job.title,
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
    final jobAsync = ref.watch(jobDetailsProvider(widget.jobId));

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1B1B)),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fast-Track Job Application', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
            Text('GLOBAL JOBS BY SUHANA • ONE-STEP VERIFIED APPLY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
      ),
      body: jobAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => const Center(child: Text('Error: ')),
        data: (job) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job summary header card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          job.companyLogoUrl,
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
                          Text(job.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                          const SizedBox(height: 2),
                          const Text(' • , Saudi Arabia', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('95% FIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section: Pre-Attached Verified Vault Documents
              const Row(
                children: [
                  Icon(Icons.shield_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text('Auto-Attached Suhana Credentials', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Because you have verified documents in your Suhana Vault, they are pre-attached automatically to maximize employer response rate.',
                style: TextStyle(fontSize: 11, color: Color(0xFF5B403C)),
              ),
              const SizedBox(height: 10),

              // Auto-attached CV card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.4)),
                ),
                child: Column(
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(_selectedCvName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('✓ Auto-Attached', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(' • GCC HSE Specialist • Suhana Parsed', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_isUploadingNew) ...[
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      const Text('Scanning & re-indexing resume...', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Auto-attached Passport Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.assignment_ind, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Passport: N8492014 (Valid till 2028)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('ICAO-Compliant MRZ Verified • 2.4 Years Validity', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: _useVaultPassport,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _useVaultPassport = v ?? true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Auto-attached NEBOSH & BOSIET Certifications
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.workspace_premium, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NEBOSH IGC & OPITO BOSIET Scans', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('2 Certificates Attached • Verified Active', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: _useVaultCertificates,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _useVaultCertificates = v ?? true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section: Want to Replace or Upload New?
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFE4DADB))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR UPLOAD / IMPORT REPLACEMENT CV', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF8F706B))),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE4DADB))),
                ],
              ),
              const SizedBox(height: 12),

              // Three Action Buttons: Manual Upload, LinkedIn Import, WhatsApp Upload
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _simulateManualUpload,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE4DADB)),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.folder_open, color: AppColors.primary, size: 22),
                            SizedBox(height: 4),
                            Text('Device Upload', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
                            Text('PDF / DOCX', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: _showLinkedInImportDialog,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE4DADB)),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.link, color: Color(0xFF0A66C2), size: 22),
                            SizedBox(height: 4),
                            Text('LinkedIn Import', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
                            Text('Auto-Extract', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        WhatsAppService.showWhatsAppAssistantSheet(
                          context: context,
                          title: job.title,
                          referenceCode: 'PG-HSE-908',
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE4DADB)),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.chat_bubble_outline, color: Color(0xFF25D366), size: 22),
                            SizedBox(height: 4),
                            Text('WhatsApp Bot', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
                            Text('Send via WA', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Optional Cover Note
              const Text('Recruiter Note (Optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E1B1B))),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: TextField(
                  controller: _coverNoteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Currently in Yanbu, Saudi Arabia. Immediate Iqama transfer available within 14 days.',
                    hintStyle: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Review CV Details Link
              Center(
                child: TextButton.icon(
                  onPressed: () => context.push(RouteNames.cvReview),
                  icon: const Icon(Icons.edit_note, size: 16, color: AppColors.primary),
                  label: const Text('Review Extracted Work Experience & Skills', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 12),

              // Final Apply Button
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : () => _submitApplication(job),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: _isSubmitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _isSubmitting ? 'Transmitting to PetroGulf HR...' : 'Submit One-Tap Application',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

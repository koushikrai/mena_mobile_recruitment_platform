import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';

class CVUploadScreen extends ConsumerStatefulWidget {
  const CVUploadScreen({super.key});

  @override
  ConsumerState<CVUploadScreen> createState() => _CVUploadScreenState();
}

class _CVUploadScreenState extends ConsumerState<CVUploadScreen> {
  String _fileName = 'Ahmed_Mansoor_HSE_CV_2026.pdf';
  String _fileMeta = '1.8 MB • GCC HSE Specialist';
  double _parseProgress = 0.94;
  bool _isUploading = false;

  void _handleManualUpload() async {
    setState(() {
      _isUploading = true;
      _parseProgress = 0.15;
    });

    for (int i = 2; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() {
        _parseProgress = i / 10.0;
      });
    }

    if (!mounted) return;
    setState(() {
      _isUploading = false;
      _fileName = 'Selected_Resume_HSE_Verified.pdf';
      _fileMeta = '2.1 MB • Oil & Gas Specialist';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Document uploaded & parsed successfully!'),
        backgroundColor: Color(0xFF059669),
      ),
    );
  }

  void _showLinkedInModal() {
    final controller = TextEditingController(text: 'https://linkedin.com/in/ahmed-mansoor-hse');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.link, color: Color(0xFF0A66C2)),
            SizedBox(width: 8),
            Text('Import from LinkedIn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your LinkedIn public profile link or username to import work experience, licenses, and verified skills.',
              style: TextStyle(fontSize: 12, color: Color(0xFF5B403C)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'LinkedIn URL',
                prefixIcon: const Icon(Icons.person, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _fileName = 'LinkedIn_Extracted_Ahmed_Mansoor.pdf';
                _fileMeta = '1.5 MB • LinkedIn Profile Sync';
                _parseProgress = 1.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ LinkedIn profile imported and parsed!'),
                  backgroundColor: Color(0xFF0A66C2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A66C2),
              foregroundColor: Colors.white,
            ),
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Step Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: Color(0xFF6E0000)),
                      SizedBox(width: 4),
                      Text('Step 1 of 4: AI Resume Parsing', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                    ],
                  ),
                  Text('%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 6),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: LinearProgressIndicator(
                  value: _parseProgress,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFE4DADB),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6E0000)),
                ),
              ),
              const SizedBox(height: 14),

              // Title Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(9999)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_outlined, size: 12, color: Color(0xFF334155)),
                    SizedBox(width: 4),
                    Text('GLOBAL JOBS BY SUHANA • GCC DIRECT RELOCATION', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF334155))),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text('Upload Your CV / Resume', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
              const SizedBox(height: 4),
              const Text('Our AI parser extracts your Gulf work experience, trades, and certifications to auto-fill your profile in seconds.', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
              const SizedBox(height: 16),

              // Upload Drop Zone (matching Screenshot 5)
              GestureDetector(
                onTap: _handleManualUpload,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4BEB8), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF6E0000), size: 30),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Color(0xFF6E0000), shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFormatBadge(Icons.picture_as_pdf, 'PDF'),
                          const SizedBox(width: 6),
                          _buildFormatBadge(Icons.description, 'DOCX'),
                          const SizedBox(width: 6),
                          const Text('Up to 10MB', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Tap to browse files', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
                      const SizedBox(height: 2),
                      const Text('or drop your file directly from WhatsApp / Files', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: _handleManualUpload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFF1E1B1B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        icon: const Icon(Icons.folder_open, size: 16),
                        label: Text(_isUploading ? 'Uploading...' : 'Select Document', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Active Upload Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: const Color(0xFFFFDAD4), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.description_outlined, color: Color(0xFF6E0000), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_fileName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 1),
                              Text(_fileMeta, style: const TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 18, color: Color(0xFF64748B)),
                          onPressed: _handleManualUpload,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: Color(0xFF6E0000), shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _parseProgress >= 1.0 ? 'AI Extraction 100% Complete' : 'AI Extraction % Complete',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E0000)),
                                  ),
                                ],
                              ),
                              Text('%', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: LinearProgressIndicator(
                              value: _parseProgress,
                              minHeight: 4,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6E0000)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildStatusItem('Contact & Personal Information Extracted', isDone: _parseProgress >= 0.3),
                    _buildStatusItem('6.8 Yrs GCC Oil & Gas Experience Detected', isDone: _parseProgress >= 0.6),
                    _buildStatusItem('NEBOSH IGC & BOSIET Certifications Identified', isDone: _parseProgress >= 0.8),
                    _buildStatusItem('Parsing Trade Licenses & Relocation Availability...', isDone: _parseProgress >= 1.0),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Fast Import Alternatives Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFE4DADB))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('FAST IMPORT ALTERNATIVES', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF8F706B))),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE4DADB))),
                ],
              ),
              const SizedBox(height: 12),

              // LinkedIn & WhatsApp Alternatives
              InkWell(
                onTap: _showLinkedInModal,
                borderRadius: BorderRadius.circular(10),
                child: _buildAlternativeCard(
                  icon: Icons.link,
                  title: 'Import from LinkedIn',
                  subtitle: 'Pre-fill skills, tenure, and recommendations',
                  trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  WhatsAppService.showWhatsAppAssistantSheet(
                    context: context,
                    title: 'Offshore HSE Supervisor',
                    referenceCode: 'CV-DIRECT-908',
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: _buildAlternativeCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Upload via WhatsApp',
                  subtitle: 'Send CV to +966 Suhana Bot',
                  tag: 'Bot',
                  trailing: const Icon(Icons.arrow_outward, size: 16, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(height: 14),

              // Suhana Privacy Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: Color(0xFF6E0000)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Suhana Privacy & GCC Employer Protection: Your resume is encrypted and only shared with licensed MHRSD & MOH accredited sponsors.',
                        style: TextStyle(fontSize: 10, color: Color(0xFF334155)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Quick Footer Badges
              Row(
                children: [
                  Expanded(
                    child: _buildFooterBadge(Icons.flight_takeoff, 'FAST RELOCATION', 'KSA, UAE, Qatar'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFooterBadge(Icons.verified_user, 'DIRECT SPONSOR', 'Zero Agent Fee'),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // CTA Button
              ElevatedButton.icon(
                onPressed: () => context.go(RouteNames.cvReview),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6E0000),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Text('Continue to Review & Edit (AI Parsed)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                label: const Icon(Icons.arrow_forward, size: 16),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => context.go(RouteNames.cvReview),
                  child: const Text('Skip and enter manually', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF334155)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String text, {required bool isDone}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Icon(isDone ? Icons.check : Icons.sync, size: 14, color: isDone ? const Color(0xFF059669) : const Color(0xFF6E0000)),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10, color: Color(0xFF1E1B1B)))),
        ],
      ),
    );
  }

  Widget _buildAlternativeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? tag,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE4DADB))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: const Color(0xFF334155)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    if (tag != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)),
                        child: Text(tag, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildFooterBadge(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE4DADB))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 16, color: const Color(0xFF334155)),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              Text(sub, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
            ],
          ),
        ],
      ),
    );
  }
}

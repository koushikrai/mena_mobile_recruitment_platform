import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';

class CVUploadScreen extends ConsumerWidget {
  const CVUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  const Text('25%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 6),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: const LinearProgressIndicator(
                  value: 0.25,
                  minHeight: 4,
                  backgroundColor: Color(0xFFE4DADB),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E0000)),
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
              Container(
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF1E1B1B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      icon: const Icon(Icons.folder_open, size: 16),
                      label: const Text('Select Document', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Active Upload Card (Ahmed_Mansoor_HSE_CV...)
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
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ahmed_Mansoor_HSE_CV_20...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              SizedBox(height: 1),
                              Text('1.8 MB • GCC HSE Specialist', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                            ],
                          ),
                        ),
                        const Icon(Icons.close, size: 16, color: Color(0xFF64748B)),
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
                                  const Text('AI Extraction 94% Complete', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                                ],
                              ),
                              const Text('94%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: const LinearProgressIndicator(
                              value: 0.94,
                              minHeight: 4,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E0000)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildStatusItem('Contact & Personal Information Extracted', isDone: true),
                    _buildStatusItem('6.8 Yrs GCC Oil & Gas Experience Detected', isDone: true),
                    _buildStatusItem('NEBOSH IGC & BOSIET Certifications Identified', isDone: true),
                    _buildStatusItem('Parsing Trade Licenses & Relocation Availability...', isDone: false),
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
              _buildAlternativeCard(
                icon: Icons.link,
                title: 'Import from LinkedIn',
                subtitle: 'Pre-fill skills, tenure, and recommendations',
                trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 8),
              _buildAlternativeCard(
                icon: Icons.chat_bubble_outline,
                title: 'Upload via WhatsApp',
                subtitle: 'Send CV to +966 Suhana Bot',
                tag: 'Bot',
                trailing: const Icon(Icons.arrow_outward, size: 16, color: Color(0xFF64748B)),
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
              const Center(
                child: Text('Skip and enter manually', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
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

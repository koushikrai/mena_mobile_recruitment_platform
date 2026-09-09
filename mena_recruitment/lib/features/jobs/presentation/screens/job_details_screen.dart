import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/widgets/whatsapp_chat_button.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/providers/bookmark_provider.dart';
import 'package:mena_recruitment/features/jobs/providers/job_details_provider.dart';

class JobDetailsScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobDetailsProvider(jobId));
    final isSaved = ref.watch(bookmarkProvider).contains(jobId);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4DADB), width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E1B1B)),
                    onPressed: () => context.pop(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE4BEB8)),
                        ),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBwOYlqgz9hq3-QkZMTQKrk8RqrIN4FGFSQc8QYsxhhqAIMh_0WMqnASqOsLPc_vS7CyE4sGCpDEhxgxQNeb6FsaDYR5rhekKgxiLZ64De4x3HsSZK5ss2AYmsXBmy1BY1SrS4grQdpvIouVZGmQH5ZUS8_L9xTWRa7GAEVahNwg5BkdcvG_XN6HVAzKVzzoUp8fcHBj7tVCeSmF0NSxyslYdH0omLOececpwsH4PC2zFbdZh82i7R-QAQnjr4ZrP-BI_0',
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.work, color: AppColors.primary, size: 16),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job Details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1B1B),
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'GLOBAL JOBS • BY SUHANA',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share_outlined, color: Color(0xFF1E1B1B), size: 20),
                        onPressed: () {},
                      ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJ992QdS9CilPYhNuYNFkGwU5BnHG2W7sRwQMB21nJfpnCdP0RmTAtTi0lAWeKS81Nu7QR26Y7kK0JPBzMva_TER6MuPTV1lEJ0fcDj7aMWGiH8ta0vX3k9ia1VphDVwk7-if6ruXF4iZY-skuffMpbicfPMJm7OVXLdUbVhYDSTB8Ttsz0aq2pNO5d6ZmJYiUFx9NCmgQ1aNESg-u-fA7MteMQAf33DVAK5NIEeUz1feWl-mJOleuw',
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: jobAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (job) => _buildBody(context, job, ref, isSaved),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE4DADB), width: 0.5)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: isSaved ? AppColors.primary : const Color(0xFF1E1B1B),
                  ),
                  onPressed: () => ref.read(bookmarkProvider.notifier).toggleBookmark(jobId),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined, color: Color(0xFF1E1B1B)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              WhatsAppChatButton(
                jobTitle: jobAsync.valueOrNull?.title ?? 'Offshore HSE Supervisor',
                referenceCode: 'PG-HSE-908',
                isCompact: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/jobs/$jobId/apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('One-Tap Apply', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          SizedBox(width: 4),
                          Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                        ],
                      ),
                      Text('Using Verified Passport & CV v2.4', style: TextStyle(fontSize: 9, color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Job job, WidgetRef ref, bool isSaved) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image with Badges
          Stack(
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDs-2n5_Xkj2vrxXdOf2fHsOMdsLLjyHxlt2zdSglN6_hNoax51Oy7zvrFWVg5wE92lNPIzitVFTiVUp-oEzavNgACz4k3TFFQCNQNGgNlpPaCeDrr7_Mq0ocBcf18c-rrT9U_qaCpPNt2viUaUq0zWEODqB5wpAV-Ozpd16hE_BTt7YkEfTgsvzhqYmMv99HUKEt5rh4zAPN-01d4GOoIrMoexzML6K8mbSSd0tRvl3_GT5-xT166wmw',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(color: Colors.black45),
                ),
              ),
              Positioned(
                top: 12,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 6),
                          SizedBox(width: 4),
                          Text('GLOBAL JOBS • SUHANA', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF990000).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, color: Colors.white, size: 10),
                          SizedBox(width: 4),
                          Text('MHRSD LICENSED #40518', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Main Header Floating Card
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4DADB)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE4DADB)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              job.companyLogoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(Icons.business, color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(job.companyName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.check_circle, color: Color(0xFF059669), size: 14),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDF2F2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('REF: PG-HSE-908', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary, fontFamily: 'monospace')),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Text('🇸🇦', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(job.city, style: const TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(job.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF6E0000))),
                    const SizedBox(height: 4),
                    const Text('Offshore Drilling Operations • Rotation: 28 Days On / 28 Days Off', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildBadge(Icons.business, 'Direct Employer'),
                        _buildBadge(Icons.badge, 'Full-Time Expat'),
                        _buildBadge(Icons.bolt, 'Fast-Track Mobilization', isAmber: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4-Quadrant Stats Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
              children: [
                _buildStatBox('MONTHLY PAY', Icons.payments_outlined, 'SAR 15.5k - 18k', '100% Tax-Free', isRed: true),
                _buildStatBox('TENURE', Icons.handshake_outlined, '2 Years', 'Indefinitely Renewable'),
                _buildStatBox('VISA ALLOCATION', Icons.badge_outlined, 'Sponsored Iqama', '100% Company Covered', isGreen: true),
                _buildStatBox('FULL PROVISIONS', Icons.apartment_outlined, 'Food + Suite', '+ Annual Return Flights'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Exceptional Profile Match Module (Tier 1 Fit)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF9F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0DCD9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Center(
                              child: Text('95%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Exceptional Profile Match', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                              Text('Based on your Global Jobs Verified Vault', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: const Text('TIER 1 FIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildMatchRow('NEBOSH IGC 1, 2, 3 Certified', isMatch: true),
                  _buildMatchRow('Offshore OPITO BOSIET + EBS', isMatch: true),
                  _buildMatchRow('Saudi Aramco Approval Card (SAP ID)', isMatch: true),
                  _buildMatchRow('Defensive Driving License (KSA)', isMatch: false),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE4DADB)),
                    ),
                    child: const Text(
                      '💡 Employer Note: Defensive driving can be completed on-site during week 1 company onboarding.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF5B403C)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Role & Responsibilities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4DADB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.engineering_rounded, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text('Role & Responsibilities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(job.jobDescription, style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF1E1B1B))),
                  const SizedBox(height: 12),
                  ...job.responsibilities.asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF2F2),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFF0DCD9)),
                              ),
                              child: Center(child: Text('${e.key + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary))),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.value, style: const TextStyle(fontSize: 11, height: 1.3, color: Color(0xFF1E1B1B)))),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Prerequisites Checklist
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4DADB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.rule_rounded, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text('Prerequisites Checklist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(4)),
                        child: const Text('4 / 4 PASSED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF065F46))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCheckTile('GCC Oil & Gas Experience', 'Min. 5+ years required • Your profile: 6.8 years (ADNOC & KJO)'),
                  _buildCheckTile('NEBOSH International General Certificate', 'IGC 1, 2, 3 Validated • Verified digital credential attached'),
                  _buildCheckTile('Passport Validity Check', 'Must exceed 6 months • Your passport has 2.4 years remaining'),
                  _buildCheckTile('GAMCA Medical Fitness', 'Authorized center clearance required upon job offer acceptance'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Institutional Transparency (from Screenshot 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF9F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0DCD9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.primary, size: 18),
                      SizedBox(width: 6),
                      Text('Institutional Transparency', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTransparencyRow('Approved Recruitment Partner:', 'Arabian Maritime Talent Lic. #772'),
                  _buildTransparencyRow('Hiring Interview Mode:', 'MS Teams Technical Panel'),
                  _buildTransparencyRow('Target Mobilization Window:', 'Within 30 Days of Visa Issue'),
                  _buildTransparencyRow('Pre-deployment Fees:', 'SAR 0.00 (100% Free - Law Compliant)', isHighlight: true),
                  const Divider(height: 16, color: Color(0xFFE4BEB8)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DIGITAL CRYPTOGRAPHIC STAMP • SUHANA VERIFIED', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        SizedBox(height: 2),
                        Text('ID: 3Z-91-F8952-PF318-OP-5NC-872', style: TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, {bool isAmber = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAmber ? const Color(0xFFFDF2F2) : const Color(0xFFF9F4F4),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isAmber ? const Color(0xFFF0DCD9) : const Color(0xFFE4DADB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isAmber ? AppColors.primary : const Color(0xFF5B403C)),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isAmber ? AppColors.primary : const Color(0xFF5B403C))),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, IconData icon, String val, String sub, {bool isRed = false, bool isGreen = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4DADB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
              Icon(icon, size: 16, color: AppColors.primary),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isRed ? AppColors.primary : const Color(0xFF1E1B1B))),
              Text(sub, style: TextStyle(fontSize: 10, fontWeight: isGreen ? FontWeight.w700 : FontWeight.w500, color: isGreen ? const Color(0xFF065F46) : const Color(0xFF5B403C))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchRow(String title, {required bool isMatch}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(isMatch ? Icons.check_circle : Icons.info, size: 14, color: isMatch ? const Color(0xFF059669) : AppColors.primary),
          const SizedBox(width: 6),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 11))),
          Text(isMatch ? 'MATCH' : 'NOT PROVIDED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: isMatch ? const Color(0xFF059669) : AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildCheckTile(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF9F4F4), borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user, color: Color(0xFF059669), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransparencyRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
          Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isHighlight ? const Color(0xFF059669) : const Color(0xFF1E1B1B))),
        ],
      ),
    );
  }
}

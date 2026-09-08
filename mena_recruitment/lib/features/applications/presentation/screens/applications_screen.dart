import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  int selectedTabIndex = 0;

  final List<String> filterTabs = [
    'ALL (5)',
    'IN PROGRESS (3)',
    'INTERVIEW STAGE (1)',
    'SELECTED (1)',
    'ARCHIVED (0)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4DADB), width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE4BEB8)),
                        ),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBwOYlqgz9hq3-QkZMTQKrk8RqrIN4FGFSQc8QYsxhhqAIMh_0WMqnASqOsLPc_vS7CyE4sGCpDEhxgxQNeb6FsaDYR5rhekKgxiLZ64De4x3HsSZK5ss2AYmsXBmy1BY1SrS4grQdpvIouVZGmQH5ZUS8_L9xTWRa7GAEVahNwg5BkdcvG_XN6HVAzKVzzoUp8fcHBj7tVCeSmF0NSxyslYdH0omLOececpwsH4PC2zFbdZh82i7R-QAQnjr4ZrP-BI_0',
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.shield, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Global Jobs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                          Text('BY SUHANA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.8)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF2F2),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: const Color(0xFFF0DCD9)),
                        ),
                        child: const Row(
                          children: [
                            Text('🇸🇦', style: TextStyle(fontSize: 12)),
                            Icon(Icons.arrow_drop_down, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        children: [
                          const Icon(Icons.notifications_outlined, size: 22, color: Color(0xFF5B403C)),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJ992QdS9CilPYhNuYNFkGwU5BnHG2W7sRwQMB21nJfpnCdP0RmTAtTi0lAWeKS81Nu7QR26Y7kK0JPBzMva_TER6MuPTV1lEJ0fcDj7aMWGiH8ta0vX3k9ia1VphDVwk7-if6ruXF4iZY-skuffMpbicfPMJm7OVXLdUbVhYDSTB8Ttsz0aq2pNO5d6ZmJYiUFx9NCmgQ1aNESg-u-fA7MteMQAf33DVAK5NIEeUz1feWl-mJOleuw',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                    Text('Live tracking across Gulf employers & visa sponsors', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFFFDAD4), borderRadius: BorderRadius.circular(9999)),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Color(0xFF6E0000), size: 6),
                      SizedBox(width: 4),
                      Text('4 ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF6E0000))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Horizontal Filter Tabs
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filterTabs.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 6),
                itemBuilder: (ctx, i) {
                  final isSel = selectedTabIndex == i;
                  return InkWell(
                    onTap: () => setState(() => selectedTabIndex = i),
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF6E0000) : Colors.white,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: isSel ? const Color(0xFF6E0000) : const Color(0xFFE4DADB)),
                      ),
                      child: Text(
                        filterTabs[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isSel ? Colors.white : const Color(0xFF5B403C),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Card 1: Senior Offshore HSE Supervisor (Interview Set)
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo('https://lh3.googleusercontent.com/aida-public/AB6AXuD2opF8r008YVN2mMWdXFb0vqNTmhWt2ps00YHazsQ1W_40eDc1IUQ5tCnu7Nuy9JUIXdWdWqKj2LT3Uz_EePQQ2CHIl_RtClLxJ0J2gMEIkGZ-FVScCMWC5Jt90IWqRWSZ_v7KSg00d7O5epiTRrGvImrfUHZEswTaLkWjt20h4FeyEa81sVmThAK3HDvTZZAfkCygBRUjCLxjWK7q4NhTb0xer3e8hzS-6llQqZ-UlLkQSfd2O1EqZQ'),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🇸🇦 RAS TANURA, KSA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                            SizedBox(height: 1),
                            Text('Senior Offshore HSE Supervisor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text('PetroGulf Energy Ltd.', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                          ],
                        ),
                      ),
                      _buildStatusPill('INTERVIEW SET', isRed: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildMilestoneTracker(stageText: 'Stage 3 of 4', currentStage: 3),
                  const SizedBox(height: 10),
                  // Dark Video Call Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF1C222B), borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.video_call, color: Color(0xFFFFB4A8), size: 20),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('TECHNICAL PANEL VIDEO', style: TextStyle(color: Color(0xFFFFB4A8), fontSize: 8, fontWeight: FontWeight.w800)),
                                    Text('Microsoft Teams Video Link', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF990000), borderRadius: BorderRadius.circular(4)),
                              child: const Text('CONFIRMED', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildTeamsInfo('DATE & SLOT', 'Mon, 28 Oct • 11:30 AST')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildTeamsInfo('INTERVIEWER', 'Eng. Fahad Al-Mutawa')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                icon: const Icon(Icons.calendar_month, size: 14),
                                label: const Text('Add Calendar', style: TextStyle(fontSize: 11)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF990000),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                icon: const Icon(Icons.videocam, size: 14),
                                label: const Text('Join Test Call', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 12),

            // Card 2: Lead MEP Technician (Action Needed)
            _buildCardContainer(
              borderColor: const Color(0xFFFFCDD2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo('https://lh3.googleusercontent.com/aida-public/AB6AXuCzq185i6-PnVYtLWt40PVt6NDVHaux4NHRD4q2gsN08jZbAU4zk5s08HbYsSqA5nJTNBpA4Kxqwlr_BmtnhlV611HdTjkTwYDGIyY6m1EHYrnnj3EUsfVo5wBV_VggIGBvaemP5N9b7VQOhNKcbAeckK4P0TYzkbpRqOx_1Q-I43GE6YEmm9fplf-SLdtfGeBrLJPKB9P8xm8CCJpRZ77sxuV2i2pKLZnWaRMCQ-dvpnvSjoH1ixYxug'),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🇦🇪 DUBAI, UAE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                            SizedBox(height: 1),
                            Text('Lead MEP Technician', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text('Al Habtoor FM Services', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                          ],
                        ),
                      ),
                      _buildStatusPill('ACTION NEEDED', isOrange: true),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFFEDD5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.upload_file, size: 14, color: Color(0xFFC2410C)),
                            SizedBox(width: 6),
                            Text('RECRUITER DOCUMENT NOTICE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFC2410C))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Please upload attested Diploma / Trade Certificate to proceed to client shortlisting.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF1E1B1B)),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF990000),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const Icon(Icons.upload, size: 14),
                          label: const Text('Upload Document Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Applied 6 days ago', style: TextStyle(fontSize: 10, color: Color(0xFF8F706B))),
                      Text('Salary: AED 5,500 + Accomm.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Card 3: QA/QC Welding Inspector (In Review)
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo('https://lh3.googleusercontent.com/aida-public/AB6AXuATLnayKblm5uLj4MinzL_dk9YyRQrh0oZr7t-KsGgSEei1JMVt7Z18tZ_cNLX4gkVPyqw-i2J67HfQyL1NRm2aMwe_C1EfJ_q8E4rT4ShSflnm7bju9UsO9GEF3aY3ZtnNwjmbDsf_Os9A5E-UID_lOAYrFnbYoIpXHkpYj26E4VFiw_df80-MUHiwAQ5BvuHgF00-huZBMmJgMOW1HuJN3Ekwi8y_IFZ5cFVRjLOvE5oPQt9rG1M5KA'),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🇶🇦 RAS LAFFAN, QATAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                            SizedBox(height: 1),
                            Text('QA/QC Welding Inspector', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text('Consolidated Contractors Co (CCC)', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                          ],
                        ),
                      ),
                      _buildStatusPill('IN REVIEW', isGrey: true),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                    child: const Row(
                      children: [
                        Icon(Icons.person_search, size: 14, color: Color(0xFF334155)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text('Recruiter Screening Active • Submitted 3 days ago • 14 candidates under review', style: TextStyle(fontSize: 10, color: Color(0xFF334155))),
                        ),
                        Icon(Icons.circle, color: Color(0xFF990000), size: 6),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Visa: Single Work Permit', style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                      Text('QAR 8,200 / mo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Card 4: HSE Officer (Turnaround Project)
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo('https://lh3.googleusercontent.com/aida-public/AB6AXuDs-2n5_Xkj2vrxXdOf2fHsOMdsLLjyHxlt2zdSglN6_hNoax51Oy7zvrFWVg5wE92lNPIzitVFTiVUp-oEzavNgACz4k3TFFQCNQNGgNlpPaCeDrr7_Mq0ocBcf18c-rrT9U_qaCpPNt2viUaUq0zWEODqB5wpAV-Ozpd16hE_BTt7YkEfTgsvzhqYmMv99HUKEt5rh4zAPN-01d4GOoIrMoexzML6K8mbSSd0tRvl3_GT5-xT166wmw'),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🇸🇦 JUBAIL INDUSTRIAL, KSA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                            SizedBox(height: 1),
                            Text('HSE Officer (Turnaround Project)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text('Sabic Strategic Maintenance Partner', style: TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                          ],
                        ),
                      ),
                      _buildStatusPill('SELECTED', isGreen: true),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFA7F3D0))),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: Color(0xFF059669)),
                            SizedBox(width: 6),
                            Text('Offer Letter In Issuance', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text('Next step: GAMCA medical fitness clearance test & visa attestation pack dispatch.', style: TextStyle(fontSize: 10, color: Color(0xFF047857))),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Target Mobilization: 15 Dec 2024', style: TextStyle(fontSize: 9, color: Color(0xFF065F46))),
                            Text('SAR 9,500 / mo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E1B1B),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: const Icon(Icons.location_on, size: 14),
                          label: const Text('GAMCA Centers', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF990000),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: const Icon(Icons.description, size: 14),
                          label: const Text('View Offer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pipeline Helpline Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFEDD5)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFFFEDD5), shape: BoxShape.circle),
                    child: const Icon(Icons.headset_mic, size: 18, color: Color(0xFFC2410C)),
                  ),
                  const SizedBox(height: 6),
                  const Text('Need help with your pipeline?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E1B1B))),
                  const SizedBox(height: 2),
                  const Text('Chat directly with your assigned Suhana talent advisor for expedited visa, interview, or clearance status.', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Color(0xFF5B403C))),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          icon: const Icon(Icons.chat, size: 14),
                          label: const Text('WhatsApp Help', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9), foregroundColor: const Color(0xFF1E1B1B), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          icon: const Icon(Icons.support_agent, size: 14),
                          label: const Text('In-App Support', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child, Color? borderColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor ?? const Color(0xFFE4DADB)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: child,
    );
  }

  Widget _buildLogo(String url) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4DADB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(url, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => const Icon(Icons.business, size: 24)),
      ),
    );
  }

  Widget _buildStatusPill(String text, {bool isRed = false, bool isOrange = false, bool isGrey = false, bool isGreen = false}) {
    Color bg = const Color(0xFFF1F5F9);
    Color fg = const Color(0xFF1E1B1B);
    if (isRed) {
      bg = const Color(0xFFFFDAD4);
      fg = const Color(0xFF6E0000);
    } else if (isOrange) {
      bg = const Color(0xFFFFEDD5);
      fg = const Color(0xFFC2410C);
    } else if (isGreen) {
      bg = const Color(0xFFD1FAE5);
      fg = const Color(0xFF065F46);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _buildMilestoneTracker({required String stageText, required int currentStage}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('HIRING MILESTONE TRACKER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF5B403C))),
              Text(stageText, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildMilestonePoint('14 Oct', isDone: true),
              _buildLine(isDone: true),
              _buildMilestonePoint('19 Oct', isDone: true),
              _buildLine(isDone: true),
              _buildMilestonePoint('28 Oct', isCurrent: true),
              _buildLine(isDone: false),
              _buildMilestonePoint('Offer', isFuture: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonePoint(String label, {bool isDone = false, bool isCurrent = false, bool isFuture = false}) {
    Widget icon = const SizedBox();
    Color bg = const Color(0xFFE2E8F0);
    if (isDone) {
      bg = const Color(0xFF1E293B);
      icon = const Icon(Icons.check, size: 10, color: Colors.white);
    } else if (isCurrent) {
      bg = const Color(0xFF990000);
      icon = const Icon(Icons.videocam, size: 10, color: Colors.white);
    }
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Center(child: icon),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 8, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, color: isCurrent ? AppColors.primary : const Color(0xFF5B403C))),
      ],
    );
  }

  Widget _buildLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? const Color(0xFF990000) : const Color(0xFFCBD5E1),
        margin: const EdgeInsets.only(bottom: 10),
      ),
    );
  }

  Widget _buildTeamsInfo(String label, String val) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 7, color: Colors.white60, fontWeight: FontWeight.bold)),
          const SizedBox(height: 1),
          Text(val, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

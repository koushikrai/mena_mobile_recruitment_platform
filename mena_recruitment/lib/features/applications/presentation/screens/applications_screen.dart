import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';
import 'package:mena_recruitment/core/widgets/notifications_sheet.dart';
import 'package:mena_recruitment/features/applications/domain/application_entity.dart';
import 'package:mena_recruitment/features/applications/providers/applications_provider.dart';
import 'package:mena_recruitment/core/network/realtime_provider.dart';
import 'package:mena_recruitment/core/network/realtime_service.dart';
import 'package:mena_recruitment/core/network/realtime_event.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  int selectedTabIndex = 0;

  final List<String> filterTabs = [
    'ALL',
    'IN PROGRESS',
    'INTERVIEW STAGE',
    'OFFER / SELECTED',
  ];

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(applicationsProvider);
    final realtimeStatus = ref.watch(realtimeStatusProvider).value ?? RealtimeConnectionStatus.disconnected;

    // Listen for live pipeline updates and show interactive toast
    ref.listen<AsyncValue<PipelineStageChangedEvent>>(pipelineUpdatesProvider, (previous, next) {
      final event = next.value;
      if (event != null && mounted) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF0F1E36),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Update: ${event.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                      ),
                      Text(
                        event.description,
                        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });


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
                      // Live Real-Time Connection Indicator
                      Container(
                        height: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: realtimeStatus == RealtimeConnectionStatus.connected
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: realtimeStatus == RealtimeConnectionStatus.connected
                                ? const Color(0xFFA7F3D0)
                                : const Color(0xFFFDE68A),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: realtimeStatus == RealtimeConnectionStatus.connected
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              realtimeStatus == RealtimeConnectionStatus.connected ? 'LIVE' : 'SYNC',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: realtimeStatus == RealtimeConnectionStatus.connected
                                    ? const Color(0xFF065F46)
                                    : const Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
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
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, size: 22, color: Color(0xFF5B403C)),
                            onPressed: () => NotificationsSheet.show(context),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => context.go(RouteNames.profile),
                        borderRadius: BorderRadius.circular(9999),
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJ992QdS9CilPYhNuYNFkGwU5BnHG2W7sRwQMB21nJfpnCdP0RmTAtTi0lAWeKS81Nu7QR26Y7kK0JPBzMva_TER6MuPTV1lEJ0fcDj7aMWGiH8ta0vX3k9ia1VphDVwk7-if6ruXF4iZY-skuffMpbicfPMJm7OVXLdUbVhYDSTB8Ttsz0aq2pNO5d6ZmJYiUFx9NCmgQ1aNESg-u-fA7MteMQAf33DVAK5NIEeUz1feWl-mJOleuw',
                          ),
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
      body: applicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading applications: $err')),
        data: (applications) {
          final filtered = applications.where((app) {
            if (selectedTabIndex == 1) {
              return app.currentStage == RelocationStage.applied ||
                  app.currentStage == RelocationStage.screening;
            } else if (selectedTabIndex == 2) {
              return app.currentStage == RelocationStage.interview;
            } else if (selectedTabIndex == 3) {
              return app.currentStage == RelocationStage.offerIssued ||
                  app.currentStage == RelocationStage.visaProcessing ||
                  app.currentStage == RelocationStage.flightOnboarding;
            }
            return true;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(applicationsProvider),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                        child: Row(
                          children: [
                            const Icon(Icons.circle, color: Color(0xFF6E0000), size: 6),
                            const SizedBox(width: 4),
                            Text('${applications.length} ACTIVE', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF6E0000))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (applications.isNotEmpty && (applications.first.currentStage == RelocationStage.applied || applications.first.currentStage == RelocationStage.screening)) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF334155)),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
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
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'LATEST APPLIED JOB TRACKING',
                                    style: TextStyle(color: Color(0xFF86EFAC), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.4)),
                                ),
                                child: const Text(
                                  'STAGE 1 OF 6',
                                  style: TextStyle(color: Color(0xFF86EFAC), fontSize: 9, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            applications.first.jobTitle,
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${applications.first.companyName} • ${applications.first.city}, ${applications.first.countryCode}',
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt, color: Color(0xFFFDE047), size: 14),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    applications.first.statusLabel,
                                    style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),

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

                  if (filtered.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(Icons.assignment_outlined, size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text('No applications in this category', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B403C))),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => context.go(RouteNames.jobs),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              child: const Text('Explore GCC Jobs'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filtered.map((app) => _buildApplicationCard(app)),

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
                                onPressed: () {
                                  WhatsAppService.showWhatsAppAssistantSheet(
                                    context: context,
                                    title: 'GCC Mobilization Support',
                                    referenceCode: 'SUHANA-PIPELINE-HELPLINE',
                                  );
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22C55E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                icon: const Icon(Icons.chat, size: 14),
                                label: const Text('WhatsApp Help', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => NotificationsSheet.show(context),
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9), foregroundColor: const Color(0xFF1E1B1B), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                icon: const Icon(Icons.support_agent, size: 14),
                                label: const Text('Compliance Alerts', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
        },
      ),
    );
  }

  Widget _buildApplicationCard(JobApplication app) {
    final flag = app.countryCode == 'KSA' || app.countryCode == 'SAU'
        ? '🇸🇦'
        : app.countryCode == 'UAE' || app.countryCode == 'ARE'
            ? '🇦🇪'
            : app.countryCode == 'QAT'
                ? '🇶🇦'
                : '🌍';

    final isInterview = app.currentStage == RelocationStage.interview;
    final isOffer = app.currentStage == RelocationStage.offerIssued;
    final isVisa = app.currentStage == RelocationStage.visaProcessing ||
        app.currentStage == RelocationStage.flightOnboarding;
    final hasMissingDoc = app.missingDocuments.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOffer
              ? const Color(0xFFA7F3D0)
              : hasMissingDoc
                  ? const Color(0xFFFFCDD2)
                  : const Color(0xFFE4DADB),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(app.companyLogoUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$flag ${app.city.toUpperCase()}, ${app.countryCode}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5B403C))),
                    const SizedBox(height: 1),
                    Text(app.jobTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                    Text(app.companyName, style: const TextStyle(fontSize: 11, color: Color(0xFF5B403C))),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 80),
                child: _buildStatusPill(
                  app.statusLabel.toUpperCase(),
                  isRed: isInterview,
                  isOrange: hasMissingDoc,
                  isGreen: isOffer || isVisa,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMilestoneTracker(stageText: 'Stage ${app.currentStage.index + 1} of 6', currentStage: app.currentStage.index),
          const SizedBox(height: 10),

          // Action Boxes based on stage
          if (isInterview) ...[
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
                      Expanded(child: _buildTeamsInfo('DATE & SLOT', app.nextDeadline != null ? '${app.nextDeadline!.day}/${app.nextDeadline!.month}/${app.nextDeadline!.year}' : 'Mon, 28 Oct • 11:30 AST')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTeamsInfo('INTERVIEWER', 'Eng. Fahad Al-Mutawa')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: 'Interview with ${app.companyName}: ${app.nextDeadline ?? "Mon, 28 Oct • 11:30 AST"}'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✓ Interview schedule copied to clipboard!')),
                            );
                          },
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
                          onPressed: () => _showTestCallDialog(app),
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
          ] else if (hasMissingDoc) ...[
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
                  Text(
                    'Missing: ${app.missingDocuments.join(", ")}. Upload attested copy to proceed with sponsor visa.',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF1E1B1B)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => context.go(RouteNames.vault),
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
          ] else if (isOffer || isVisa) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFA7F3D0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: Color(0xFF059669)),
                      const SizedBox(width: 6),
                      Text(
                        isVisa ? 'Visa Processing Active' : 'Official Offer Letter Issued',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Next: GAMCA biometric health clearance & Saudi MHRSD visa pack dispatch.', style: TextStyle(fontSize: 10, color: Color(0xFF047857))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => NotificationsSheet.show(context),
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
                          onPressed: () => _showOfferLetterModal(app),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF990000),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: const Icon(Icons.description, size: 14),
                          label: Text(
                            isVisa ? 'View Visa Packet' : 'View Offer',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (app.currentStage == RelocationStage.applied || app.currentStage == RelocationStage.screening) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: Color(0xFF16A34A), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'LIVE APPLICATION TRACKING',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF15803D), letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('STAGE 1 / 6', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Transmitted to employer HR with verified passport & CV. Initial recruiter screening underway.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF14532D)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            WhatsAppService.showWhatsAppAssistantSheet(
                              context: context,
                              title: app.jobTitle,
                              referenceCode: app.id.length > 8 ? app.id.substring(0, 8).toUpperCase() : app.id.toUpperCase(),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF15803D),
                            side: const BorderSide(color: Color(0xFF86EFAC)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: const Icon(Icons.chat, size: 14, color: Color(0xFF16A34A)),
                          label: const Text('WhatsApp HR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showApplicationTrackingModal(app),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          icon: const Icon(Icons.track_changes, size: 14),
                          label: const Text('Track Details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ref: ${app.id.substring(0, app.id.length > 8 ? 8 : app.id.length).toUpperCase()}', style: const TextStyle(fontSize: 10, color: Color(0xFF8F706B), fontFamily: 'monospace')),
              const Text('Direct Sponsor Visa', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E0000))),
            ],
          ),
        ],
      ),
    );
  }

  void _showApplicationTrackingModal(JobApplication app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                  child: const Icon(Icons.verified, color: Color(0xFF16A34A), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.jobTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      Text('${app.companyName} • ${app.city}, ${app.countryCode}', style: const TextStyle(fontSize: 12, color: Color(0xFF5B403C))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Hiring Pipeline Timeline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTimelineStep('1. Application Transmitted', 'Directly dispatched to licensed employer HR portal with verified passport.', isDone: true, isCurrent: app.currentStage == RelocationStage.applied),
            _buildTimelineStep('2. HR Screening & Shortlist', 'Recruiter review against offshore/onshore requirements.', isDone: app.currentStage.index > 0, isCurrent: app.currentStage == RelocationStage.screening),
            _buildTimelineStep('3. Technical Video Interview', 'Direct panel interview via Microsoft Teams with engineering lead.', isDone: app.currentStage.index > 1, isCurrent: app.currentStage == RelocationStage.interview),
            _buildTimelineStep('4. Formal Offer & Salary Package', 'Official contract issued with expatriate benefits and accommodation.', isDone: app.currentStage.index > 2, isCurrent: app.currentStage == RelocationStage.offerIssued),
            _buildTimelineStep('5. Visa Stamping & GAMCA Medical', 'Direct employer visa issuance through MHRSD/Qiwa portal.', isDone: app.currentStage.index > 3, isCurrent: app.currentStage == RelocationStage.visaProcessing),
            _buildTimelineStep('6. Flight Ticket & Mobilization', 'Expedited arrival and site induction handover.', isDone: app.currentStage.index > 4, isCurrent: app.currentStage == RelocationStage.flightOnboarding),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  WhatsAppService.showWhatsAppAssistantSheet(
                    context: context,
                    title: app.jobTitle,
                    referenceCode: app.id.length > 8 ? app.id.substring(0, 8).toUpperCase() : app.id.toUpperCase(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.chat),
                label: const Text('Direct Recruiter WhatsApp Query', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String title, String desc, {required bool isDone, required bool isCurrent}) {
    Color dotColor = const Color(0xFFCBD5E1);
    if (isDone) dotColor = const Color(0xFF16A34A);
    if (isCurrent) dotColor = const Color(0xFF2563EB);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            child: isDone ? const Icon(Icons.check, size: 8, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600, color: isCurrent ? const Color(0xFF2563EB) : const Color(0xFF1E1B1B))),
                Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTestCallDialog(JobApplication app) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.videocam, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Technical Interview Room', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Employer: ${app.companyName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text('Position: ${app.jobTitle}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Camera & Microphone: Ready ✓', style: TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                  Text('Bandwidth: High-Speed GCC Relay Active', style: TextStyle(fontSize: 10, color: Color(0xFF334155))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Connected to Teams Video Relay room. Standby for panel.'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Enter Virtual Room'),
          ),
        ],
      ),
    );
  }

  void _showOfferLetterModal(JobApplication app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFF059669), size: 24),
                      SizedBox(width: 8),
                      Text('Official GCC Employment Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(app.jobTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text(app.companyName, style: const TextStyle(fontSize: 13, color: Color(0xFF5B403C))),
              const SizedBox(height: 16),

              // Offer Details Table
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: const Column(
                  children: [
                    _OfferRow(label: 'Monthly Base Salary', value: 'SAR 14,000 / mo (100% Tax-Free)'),
                    Divider(height: 14),
                    _OfferRow(label: 'Accommodation', value: 'Furnished Executive Single/Family'),
                    Divider(height: 14),
                    _OfferRow(label: 'Rotation Schedule', value: '28 Days On / 28 Days Off (Paid)'),
                    Divider(height: 14),
                    _OfferRow(label: 'Air Tickets', value: 'Annual Business-Class Flight Included'),
                    Divider(height: 14),
                    _OfferRow(label: 'Visa & Stamping', value: 'Zero Candidate Fee (MOFA Guaranteed)'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await ref.read(applicationsRepositoryProvider).updateApplicationStage(
                        app.id,
                        RelocationStage.visaProcessing,
                      );
                  ref.invalidate(applicationsProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFF059669),
                        content: Text('✓ Offer accepted! Relocation Stage advanced to Visa Processing.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.thumb_up_alt_rounded),
                label: const Text('Accept Offer & Mobilize to GCC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  WhatsAppService.showWhatsAppAssistantSheet(
                    context: context,
                    title: 'Counter Offer / Query: ${app.jobTitle}',
                    referenceCode: app.id,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF5B403C),
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.chat, size: 16),
                label: const Text('Discuss Terms with Recruiter', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildStatusPill(String text, {bool isRed = false, bool isOrange = false, bool isGreen = false}) {
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
      child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: fg), overflow: TextOverflow.ellipsis, maxLines: 2),
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
              _buildMilestonePoint('Applied', isDone: currentStage > 0, isCurrent: currentStage == 0),
              _buildLine(isDone: currentStage >= 1),
              _buildMilestonePoint('Screen', isDone: currentStage > 1, isCurrent: currentStage == 1),
              _buildLine(isDone: currentStage >= 2),
              _buildMilestonePoint('Interview', isDone: currentStage > 2, isCurrent: currentStage == 2),
              _buildLine(isDone: currentStage >= 3),
              _buildMilestonePoint('Offer', isDone: currentStage > 3, isCurrent: currentStage == 3),
              _buildLine(isDone: currentStage >= 4),
              _buildMilestonePoint('Visa', isDone: currentStage > 4, isCurrent: currentStage == 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonePoint(String label, {bool isDone = false, bool isCurrent = false}) {
    Widget icon = const SizedBox();
    Color bg = const Color(0xFFE2E8F0);
    if (isDone) {
      bg = const Color(0xFF1E293B);
      icon = const Icon(Icons.check, size: 10, color: Colors.white);
    } else if (isCurrent) {
      bg = const Color(0xFF990000);
      icon = const Icon(Icons.circle, size: 8, color: Colors.white);
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

class _OfferRow extends StatelessWidget {
  final String label;
  final String value;

  const _OfferRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF5B403C))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1B1B))),
      ],
    );
  }
}

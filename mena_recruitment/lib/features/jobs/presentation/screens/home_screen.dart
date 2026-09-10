import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/job_filter_bottom_sheet.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/mega_walkin_banner.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/walkin_drive_details_sheet.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/profile_readiness_banner.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/stitch_job_card.dart';
import 'package:mena_recruitment/core/widgets/notifications_sheet.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';
import 'package:mena_recruitment/features/jobs/domain/recruitment_region.dart';
import 'package:mena_recruitment/features/jobs/providers/region_provider.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/region_selector_sheet.dart';
import 'package:mena_recruitment/features/jobs/providers/bookmark_provider.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';
import 'package:mena_recruitment/features/jobs/providers/jobs_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedRegion = ref.watch(selectedRegionProvider);
    final jobsAsync = ref.watch(jobsProvider);
    final bookmarkedJobs = ref.watch(bookmarkProvider);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.90),
            border: const Border(
              bottom: BorderSide(color: Color(0xFFE4BEB8), width: 0.4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(153, 0, 0, 0.05),
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo + Title: Suhana Logo + Global Jobs By Suhana
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE4BEB8), width: 0.6),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.04),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBwOYlqgz9hq3-QkZMTQKrk8RqrIN4FGFSQc8QYsxhhqAIMh_0WMqnASqOsLPc_vS7CyE4sGCpDEhxgxQNeb6FsaDYR5rhekKgxiLZ64De4x3HsSZK5ss2AYmsXBmy1BY1SrS4grQdpvIouVZGmQH5ZUS8_L9xTWRa7GAEVahNwg5BkdcvG_XN6HVAzKVzzoUp8fcHBj7tVCeSmF0NSxyslYdH0omLOececpwsH4PC2zFbdZh82i7R-QAQnjr4ZrP-BI_0',
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) => const Icon(
                              Icons.public_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Global Jobs',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF990000),
                              letterSpacing: -0.5,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'BY SUHANA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5B403C),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Top right actions: GCC location button + Notifications badge + Profile
                  Row(
                    children: [
                      // Active Recruitment Region Switcher Button
                      InkWell(
                        onTap: () => RegionSelectorSheet.show(context),
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(color: const Color(0xFFFEE2E2)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(153, 0, 0, 0.04),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(selectedRegion.flag, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text(
                                selectedRegion == RecruitmentRegion.global
                                    ? 'Global'
                                    : '${selectedRegion.shortLabel} / Global',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF990000),
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(Icons.expand_more_rounded, size: 14, color: Color(0xFF990000)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, size: 22),
                            color: const Color(0xFF5B403C),
                            onPressed: () => NotificationsSheet.show(context),
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF990000),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => context.go(RouteNames.profile),
                        borderRadius: BorderRadius.circular(9999),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFEE2E2), width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9999),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAzJ992QdS9CilPYhNuYNFkGwU5BnHG2W7sRwQMB21nJfpnCdP0RmTAtTi0lAWeKS81Nu7QR26Y7kK0JPBzMva_TER6MuPTV1lEJ0fcDj7aMWGiH8ta0vX3k9ia1VphDVwk7-if6ruXF4iZY-skuffMpbicfPMJm7OVXLdUbVhYDSTB8Ttsz0aq2pNO5d6ZmJYiUFx9NCmgQ1aNESg-u-fA7MteMQAf33DVAK5NIEeUz1feWl-mJOleuw',
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(Icons.person, size: 24),
                            ),
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
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(jobsProvider),
        color: const Color(0xFF990000),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Search & Filter Controls from Stitch Page 1
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE4BEB8).withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (val) =>
                              ref.read(jobFilterProvider.notifier).setSearchQuery(val),
                          decoration: const InputDecoration(
                            hintText: 'Search roles, skills, companies (e.g. HSE Officer)...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8F706B),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Color(0xFF8F706B),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => JobFilterBottomSheet.show(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE4BEB8).withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.tune_rounded, color: Color(0xFF990000), size: 22),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF990000),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Profile Readiness Smart Alert
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ProfileReadinessBanner(
                  percentage: profileAsync.valueOrNull?.readinessScore ?? 85,
                  statusTag: (profileAsync.valueOrNull?.readinessScore ?? 85) >= 80 ? 'MRZ PASSPORT OK' : 'SETUP NEEDED',
                  recommendation: 'Add NEBOSH / IOSH cert to unlock 35 high-priority GCC roles',
                  onAddCredential: () => context.go('${RouteNames.vault}/certifications'),
                ),
              ),
              const SizedBox(height: 16),
              // Mega Walk-in Banner: Oil & Gas Turnaround 2025
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MegaWalkinBanner(
                  onViewDetails: () => WalkinDriveDetailsSheet.show(context),
                ),
              ),
              const SizedBox(height: 20),
              // Urgent Vacancies Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF990000),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Urgent Vacancies',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1B1B),
                          ),
                        ),
                        Text(
                          'Immediate processing & fast-track deployment',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5B403C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Job Cards List
              jobsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: Color(0xFF990000)),
                  ),
                ),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text('Error loading jobs: $err'),
                  ),
                ),
                data: (jobs) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: jobs.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (ctx, index) {
                      final job = jobs[index];
                      final isSaved = bookmarkedJobs.contains(job.id);
                      return StitchJobCard(
                        job: job,
                        isBookmarked: isSaved,
                        onTap: () => context.go('${RouteNames.jobs}/${job.id}'),
                        onApply: () => context.go('${RouteNames.jobs}/${job.id}'),
                        onBookmark: () =>
                            ref.read(bookmarkProvider.notifier).toggleBookmark(job.id),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

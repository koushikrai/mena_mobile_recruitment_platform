import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mena_recruitment/core/routing/route_names.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';
import 'package:mena_recruitment/features/jobs/domain/job_entity.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/quick_apply_modal.dart';
import 'package:mena_recruitment/features/jobs/presentation/widgets/stitch_job_card.dart';
import 'package:mena_recruitment/features/jobs/providers/bookmark_provider.dart';

class SavedJobsScreen extends ConsumerStatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  ConsumerState<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends ConsumerState<SavedJobsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCountryFilter = 'ALL';

  final List<String> _countryFilters = [
    'ALL',
    'SAUDI ARABIA',
    'UAE',
    'QATAR',
    'KUWAIT',
    'OMAN',
    'BAHRAIN',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Job> _filterJobs(List<Job> jobs) {
    return jobs.where((job) {
      // 1. Country filter
      if (_selectedCountryFilter != 'ALL') {
        final code = job.countryCode.toUpperCase();
        final matchesCountry = (_selectedCountryFilter == 'SAUDI ARABIA' && (code == 'KSA' || code == 'SAU')) ||
            (_selectedCountryFilter == 'UAE' && (code == 'UAE' || code == 'ARE')) ||
            (_selectedCountryFilter == 'QATAR' && (code == 'QAT' || code == 'QATAR')) ||
            (_selectedCountryFilter == 'KUWAIT' && (code == 'KWT' || code == 'KUWAIT')) ||
            (_selectedCountryFilter == 'OMAN' && (code == 'OMN' || code == 'OMAN')) ||
            (_selectedCountryFilter == 'BAHRAIN' && (code == 'BHR' || code == 'BAHRAIN'));
        if (!matchesCountry) return false;
      }

      // 2. Search query filter
      if (_searchQuery.isNotEmpty) {
        final inTitle = job.title.toLowerCase().contains(_searchQuery);
        final inCompany = job.companyName.toLowerCase().contains(_searchQuery);
        final inCity = job.city.toLowerCase().contains(_searchQuery);
        final inSkills = job.requiredSkills.any((s) => s.toLowerCase().contains(_searchQuery));
        if (!inTitle && !inCompany && !inCity && !inSkills) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final savedJobsAsync = ref.watch(savedJobsProvider);
    final bookmarkedCount = ref.watch(bookmarkProvider).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bookmark_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saved Jobs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '$bookmarkedCount ${bookmarkedCount == 1 ? "role" : "roles"} kept for later',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Contact Recruiter',
            icon: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
            onPressed: () {
              WhatsAppService.launchChat(
                message: 'Hello Suhana Recruitment Team, I have queries regarding the jobs I saved on the app.',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF0DCD9),
            height: 1.0,
          ),
        ),
      ),
      body: savedJobsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.primary, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load saved jobs',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(savedJobsProvider),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        data: (savedJobs) {
          if (savedJobs.isEmpty) {
            return _buildEmptyState(context);
          }

          final filteredList = _filterJobs(savedJobs);

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(savedJobsProvider);
            },
            child: CustomScrollView(
              slivers: [
                // Search & Filter header
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE8DDDC)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    hintText: 'Search saved titles, skills or companies...',
                                    hintStyle: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              if (_searchQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () => _searchController.clear(),
                                  child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Country Filter Pills
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _countryFilters.map((filter) {
                              final isSelected = _selectedCountryFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedCountryFilter = filter;
                                      });
                                    }
                                  },
                                  selectedColor: AppColors.primary,
                                  backgroundColor: const Color(0xFFF3ECEC),
                                  labelStyle: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: isSelected ? AppColors.primary : const Color(0xFFE5D5D3),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Subtitle summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SHOWING ${filteredList.length} OF ${savedJobs.length} SAVED',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (_selectedCountryFilter != 'ALL' || _searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCountryFilter = 'ALL';
                                _searchController.clear();
                              });
                            },
                            child: const Text(
                              'Reset Filter',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Jobs list or no matches found
                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondary),
                            const SizedBox(height: 12),
                            const Text(
                              'No matching saved roles',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try changing your search terms or selecting a different GCC country filter.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedCountryFilter = 'ALL';
                                  _searchController.clear();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                              ),
                              child: const Text('Clear Search Filter'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final job = filteredList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: StitchJobCard(
                              job: job,
                              isBookmarked: true,
                              onTap: () => context.go('${RouteNames.jobs}/${job.id}'),
                              onApply: () => QuickApplyModal.show(context, job),
                              onBookmark: () {
                                final removedJob = job;
                                ref.read(bookmarkProvider.notifier).removeBookmark(job.id);
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF1B2B48),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    content: Text('Removed "${removedJob.title}" from saved jobs'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      textColor: const Color(0xFFFF9E80),
                                      onPressed: () {
                                        ref.read(bookmarkProvider.notifier).addBookmark(removedJob.id);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: filteredList.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 2),
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                size: 46,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Saved Jobs Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bookmark verified vacancies while exploring jobs across Saudi Arabia, UAE, Qatar, Kuwait, Oman, and Bahrain. Your saved roles will stay here so you can apply whenever you are ready.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.jobs),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text(
                'Explore GCC Vacancies',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

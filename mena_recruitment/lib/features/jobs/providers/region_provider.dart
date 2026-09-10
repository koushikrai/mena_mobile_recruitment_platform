import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/jobs/domain/recruitment_region.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';

/// Currently selected active recruitment region.
final selectedRegionProvider = StateProvider<RecruitmentRegion>((ref) {
  return RecruitmentRegion.gcc;
});

/// Convenience helper to switch regions and synchronize with jobFilterProvider.
class RegionController {
  static void switchRegion(WidgetRef ref, RecruitmentRegion region) {
    ref.read(selectedRegionProvider.notifier).state = region;
    ref.read(jobFilterProvider.notifier).setRegion(region.id == 'global' ? null : region.id);
  }
}

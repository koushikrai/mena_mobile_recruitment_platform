import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/jobs/domain/job_filter.dart';

class JobFilterNotifier extends StateNotifier<JobFilter> {
  JobFilterNotifier() : super(const JobFilter());

  void toggleCountry(String countryCode) {
    final current = List<String>.from(state.selectedCountries);
    if (current.contains(countryCode)) {
      current.remove(countryCode);
    } else {
      current.add(countryCode);
    }
    state = state.copyWith(selectedCountries: current);
  }

  void toggleVisaSponsored() {
    state = state.copyWith(visaSponsored: state.visaSponsored == true ? null : true);
  }

  void toggleIqama() {
    state = state.copyWith(transferableIqama: state.transferableIqama == true ? null : true);
  }

  void toggleImmediate() {
    state = state.copyWith(immediateHiring: state.immediateHiring == true ? null : true);
  }

  void toggleHousing() {
    state = state.copyWith(housingIncluded: state.housingIncluded == true ? null : true);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = const JobFilter();
  }
}

final jobFilterProvider = StateNotifierProvider<JobFilterNotifier, JobFilter>((ref) {
  return JobFilterNotifier();
});

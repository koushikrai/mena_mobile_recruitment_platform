import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingCompletedNotifier extends StateNotifier<bool> {
  OnboardingCompletedNotifier() : super(false);

  void completeOnboarding() {
    state = true;
  }
}

final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingCompletedNotifier, bool>((ref) {
  return OnboardingCompletedNotifier();
});

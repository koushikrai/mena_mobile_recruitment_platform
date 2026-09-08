import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingCompleted extends _$OnboardingCompleted {
  @override
  bool build() => false;

  void completeOnboarding() {
    state = true;
  }
}

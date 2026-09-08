import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/parsed_cv_entity.dart';

class CVReviewNotifier extends StateNotifier<ParsedCV?> {
  CVReviewNotifier() : super(null);

  void initialize(ParsedCV cv) {
    state = cv;
  }

  void updateFullName(String name) {
    if (state != null) {
      state = state!.copyWith(fullName: name);
    }
  }
  
  // Add other update methods as needed...
}

final cvReviewProvider = StateNotifierProvider<CVReviewNotifier, ParsedCV?>((ref) {
  return CVReviewNotifier();
});

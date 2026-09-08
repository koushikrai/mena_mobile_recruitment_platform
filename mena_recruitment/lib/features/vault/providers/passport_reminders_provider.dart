import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'passport_reminders_provider.g.dart';

class PassportRemindersState {
  final bool sixMonthReminder;
  final bool threeMonthReminder;
  const PassportRemindersState({required this.sixMonthReminder, required this.threeMonthReminder});
}

@riverpod
class PassportReminders extends _$PassportReminders {
  @override
  PassportRemindersState build() => const PassportRemindersState(sixMonthReminder: true, threeMonthReminder: false);

  void toggleSixMonth(bool val) {
    state = PassportRemindersState(sixMonthReminder: val, threeMonthReminder: state.threeMonthReminder);
  }

  void toggleThreeMonth(bool val) {
    state = PassportRemindersState(sixMonthReminder: state.sixMonthReminder, threeMonthReminder: val);
  }
}

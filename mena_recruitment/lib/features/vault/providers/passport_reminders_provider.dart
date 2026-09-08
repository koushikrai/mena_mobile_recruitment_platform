import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassportRemindersState {
  final bool sixMonthReminder;
  final bool threeMonthReminder;
  const PassportRemindersState({required this.sixMonthReminder, required this.threeMonthReminder});
}

final passportRemindersProvider = NotifierProvider<PassportRemindersNotifier, PassportRemindersState>(() {
  return PassportRemindersNotifier();
});

class PassportRemindersNotifier extends Notifier<PassportRemindersState> {
  @override
  PassportRemindersState build() => const PassportRemindersState(sixMonthReminder: true, threeMonthReminder: false);

  void toggleSixMonth(bool val) {
    state = PassportRemindersState(sixMonthReminder: val, threeMonthReminder: state.threeMonthReminder);
  }

  void toggleThreeMonth(bool val) {
    state = PassportRemindersState(sixMonthReminder: state.sixMonthReminder, threeMonthReminder: val);
  }
}

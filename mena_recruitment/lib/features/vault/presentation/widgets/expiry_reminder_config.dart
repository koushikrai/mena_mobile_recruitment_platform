import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/vault/providers/passport_reminders_provider.dart';

class ExpiryReminderConfig extends ConsumerWidget {
  const ExpiryReminderConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passportRemindersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiry Alerts Configuration',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SwitchListTile(
          title: const Text('6-Month Reminder (GCC Visa Rule)'),
          value: state.sixMonthReminder,
          onChanged: (val) {
            ref.read(passportRemindersProvider.notifier).toggleSixMonth(val);
          },
        ),
        SwitchListTile(
          title: const Text('3-Month Reminder'),
          value: state.threeMonthReminder,
          onChanged: (val) {
            ref.read(passportRemindersProvider.notifier).toggleThreeMonth(val);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Alert Channels: WhatsApp, Email, Push', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}

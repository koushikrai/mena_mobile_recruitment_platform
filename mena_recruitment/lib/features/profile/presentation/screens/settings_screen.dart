import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/profile_hero_card.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/availability_toggle.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/relocation_prefs_card.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/security_settings.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/notification_settings.dart';
import 'package:mena_recruitment/features/profile/presentation/widgets/language_rtl_toggle.dart';
import 'package:mena_recruitment/features/profile/providers/profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: const Color(0xFF0F1E36),
        foregroundColor: Colors.white,
      ),
      body: profileAsync.when(
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeroCard(profile: profile),
                const SizedBox(height: 16),
                AvailabilityToggle(
                  isActivelyLooking: profile.isActivelyLooking,
                  onChanged: (val) {
                    ref.read(profileProvider.notifier).updateAvailability(val);
                  },
                ),
                const SizedBox(height: 16),
                RelocationPrefsCard(profile: profile),
                const SizedBox(height: 16),
                const SecuritySettings(),
                const SizedBox(height: 16),
                const NotificationSettings(),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  color: const Color(0xFFF8F9FF),
                  child: SwitchListTile(
                    title: const Text('Confidential Mode'),
                    subtitle: const Text('Hide profile details from current employer'),
                    value: false,
                    onChanged: (val) {},
                    secondary: const Icon(Icons.visibility_off),
                  ),
                ),
                const SizedBox(height: 16),
                const LanguageRtlToggle(),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.description, color: Color(0xFF0F1E36)),
                  title: const Text('GCC Labor Law Guide'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: Color(0xFF0F1E36)),
                  title: const Text('WhatsApp Helpline'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text('Logout'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Delete Account', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

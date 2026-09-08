import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final bool biometricEnabled;
  final bool twoFactorEnabled;
  final bool pushNotifications;
  final bool emailAlerts;
  final bool whatsappUpdates;
  final bool confidentialMode;
  final bool isRtl;

  const AppSettings({
    this.biometricEnabled = true,
    this.twoFactorEnabled = false,
    this.pushNotifications = true,
    this.emailAlerts = true,
    this.whatsappUpdates = false,
    this.confidentialMode = false,
    this.isRtl = false,
  });

  AppSettings copyWith({
    bool? biometricEnabled,
    bool? twoFactorEnabled,
    bool? pushNotifications,
    bool? emailAlerts,
    bool? whatsappUpdates,
    bool? confidentialMode,
    bool? isRtl,
  }) {
    return AppSettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      whatsappUpdates: whatsappUpdates ?? this.whatsappUpdates,
      confidentialMode: confidentialMode ?? this.confidentialMode,
      isRtl: isRtl ?? this.isRtl,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void updateSettings(AppSettings newSettings) {
    state = newSettings;
  }
}

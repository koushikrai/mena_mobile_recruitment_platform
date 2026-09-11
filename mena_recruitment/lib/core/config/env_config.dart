import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EnvConfig {
  EnvConfig._();

  static final Map<String, String> _env = {};

  /// Direct Recruiter Query Phone Number (E.164 format with country code)
  /// Loaded dynamically from .env or dart-define
  static String get directRecruiterQueryNumber {
    // 1. From loaded .env
    final fromEnv = _env['DIRECT_RECRUITER_QUERY_NUMBER'] ??
        _env['RECRUITER_PHONE'] ??
        _env['RECRUITER_WHATSAPP_NUMBER'];
    if (fromEnv != null && fromEnv.trim().isNotEmpty) {
      return fromEnv.trim();
    }

    // 2. From compile-time dart-define
    const fromDefine = String.fromEnvironment(
      'DIRECT_RECRUITER_QUERY_NUMBER',
      defaultValue: String.fromEnvironment('RECRUITER_PHONE', defaultValue: ''),
    );
    if (fromDefine.isNotEmpty) {
      return fromDefine.trim();
    }

    // 3. Fallback default
    return '+966540001122';
  }

  /// Generic accessor for any environment key
  static String get(String key, {String defaultValue = ''}) {
    return _env[key] ?? defaultValue;
  }

  /// Initialize and parse .env file from app assets
  static Future<void> init() async {
    final candidatePaths = ['.env', 'assets/.env'];
    for (final path in candidatePaths) {
      try {
        final content = await rootBundle.loadString(path);
        _parse(content);
        debugPrint('[EnvConfig] Successfully loaded environment from $path (recruiter phone: $directRecruiterQueryNumber)');
        return;
      } catch (_) {
        // Try next candidate path
      }
    }
    debugPrint('[EnvConfig] Notice: .env file not found in bundle, using default config.');
  }

  /// Helper parser for .env contents
  static void _parse(String content) {
    for (final rawLine in content.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final separatorIndex = line.indexOf('=');
      if (separatorIndex > 0) {
        final key = line.substring(0, separatorIndex).trim();
        var value = line.substring(separatorIndex + 1).trim();
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }
        _env[key] = value;
      }
    }
  }
}

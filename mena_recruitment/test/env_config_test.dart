import 'package:flutter_test/flutter_test.dart';
import 'package:mena_recruitment/core/config/env_config.dart';
import 'package:mena_recruitment/core/utils/whatsapp_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EnvConfig & Direct Recruiter Query Number', () {
    test('EnvConfig loads and parses .env correctly', () async {
      await EnvConfig.init();
      final number = EnvConfig.directRecruiterQueryNumber;
      expect(number, isNotEmpty);
      expect(number.startsWith('+'), isTrue);
      expect(WhatsAppService.defaultRecruiterPhone, equals(number));
    });

    test('EnvConfig retrieves direct recruiter query number from parsed configuration', () {
      final queryNumber = EnvConfig.directRecruiterQueryNumber;
      expect(queryNumber, isNotEmpty);
      expect(queryNumber.startsWith('+'), isTrue);
    });
  });
}

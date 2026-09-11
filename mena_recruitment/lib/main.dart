import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/app.dart';
import 'package:mena_recruitment/core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  runApp(
    const ProviderScope(
      child: MenaRecruitmentApp(),
    ),
  );
}

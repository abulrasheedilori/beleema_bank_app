import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(
    fileName: const String.fromEnvironment(
      'ENV_FILE',
      defaultValue: '.env.local',
    ),
  );
  runApp(ProviderScope(child: BeleemaApp()));
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  runApp(const ProviderScope(child: BeleemaApp()));
}

// Update this to return Future<void>
Future<void> loadEnv() async {
  try {
    await dotenv.load(
      fileName: const String.fromEnvironment(
        'ENV_FILE',
        defaultValue: '.env.prod',
      ),
    );
  } catch (e) {
    print("Error loading env file: $e");
    // Fallback or handle error
  }
}

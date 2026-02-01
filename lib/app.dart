import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_navigator.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/screen/splash_screen.dart';

class BeleemaApp extends ConsumerWidget {
  const BeleemaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      title: 'Beleema Bank App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
    );
  }
}

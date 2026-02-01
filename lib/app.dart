import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//
import 'core/navigation/navigation_service.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/screen/splash_screen.dart';

class BeleemaApp extends ConsumerWidget {
  const BeleemaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final navigation = ref.read(navigationServiceProvider);

    return MaterialApp(
      navigatorKey: navigation.navigatorKey,
      title: 'Beleema Bank App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
    );
  }
}

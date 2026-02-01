import 'package:beleema_bank_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:beleema_bank_app/features/transaction_pin/presentation/screens/set_transaction_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/password_rules.dart';
import '../notifier/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final colors = Theme.of(context).colorScheme;

    final password = _passwordCtrl.text;
    final usernameValid = _usernameCtrl.text.trim().length >= 3;
    final passwordValid = PasswordRules.isValid(password);

    final isValid = usernameValid && passwordValid;
    final isLoading = auth.loading;

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      // Show error
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }

      // Navigate ONLY on successful auth
      if (next.isAuthenticated && prev?.isAuthenticated == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => next.hasPinSet == true
                ? DashboardScreen()
                : const SetTransactionPinScreen(),
          ),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Securely access your Beleema account',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Username
              TextField(
                controller: _usernameCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Username',
                  errorText: _usernameCtrl.text.isEmpty || usernameValid
                      ? null
                      : 'Minimum 3 characters',
                ),
              ),

              const SizedBox(height: 20),

              // Password
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Password rules (real-time)
              _PasswordRule(
                text: '> 7 characters password',
                valid: PasswordRules.hasMinLength(password),
              ),
              _PasswordRule(
                text: '1 lowercase letter',
                valid: PasswordRules.hasLowercase(password),
              ),
              _PasswordRule(
                text: '1 number',
                valid: PasswordRules.hasNumber(password),
              ),

              const SizedBox(height: 36),

              // Login Button (only visible when valid)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid ? colors.primary : colors.error,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: (!isValid || isLoading)
                        ? null
                        : () {
                            ref
                                .read(authNotifierProvider.notifier)
                                .login(
                                  _usernameCtrl.text.trim(),
                                  _passwordCtrl.text.trim(),
                                );
                          },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: isLoading
                          ? SizedBox(
                              key: const ValueKey('loader'),
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.onPrimary,
                              ),
                            )
                          : Text(
                              isValid
                                  ? 'Secure Login'
                                  : 'Input Valid Credentials',
                              key: const ValueKey('text'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordRule extends StatelessWidget {
  final String text;
  final bool valid;

  const _PasswordRule({required this.text, required this.valid});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.cancel,
            size: 8,
            color: valid ? colors.primary : colors.error,
          ),
          const SizedBox(width: 2),

          Expanded(
            child: Text(
              text,
              softWrap: true,
              style: TextStyle(
                color: valid ? colors.primary : colors.error,
                fontSize: 8,
                height: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

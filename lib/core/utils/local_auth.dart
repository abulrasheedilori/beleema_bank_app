import 'package:local_auth/local_auth.dart';

final _auth = LocalAuthentication();

Future<bool> authenticateBiometric() async {
  return await _auth.authenticate(
    localizedReason: 'Confirm transaction',
    options: const AuthenticationOptions(biometricOnly: true),
  );
}

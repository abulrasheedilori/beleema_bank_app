import 'dart:convert';

import 'package:crypto/crypto.dart';

class PinHasher {
  static String hash(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    return sha256.convert(bytes).toString();
  }
}

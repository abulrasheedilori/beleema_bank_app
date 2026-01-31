class PasswordRules {
  static bool hasMinLength(String v) => v.length >= 8;
  // static bool hasUppercase(String v) => v.contains(RegExp(r'[A-Z]'));
  static bool hasLowercase(String v) => v.contains(RegExp(r'[a-z]'));
  static bool hasNumber(String v) => v.contains(RegExp(r'[0-9]'));
  // static bool hasSpecialCharacter(String v) => v.contains(RegExp(r'[@$*#_-]'));

  static bool isValid(String v) =>
      hasMinLength(v) && hasLowercase(v) && hasNumber(v);
  //&& hasUppercase(v) && hasSpecialCharacter(v);
}

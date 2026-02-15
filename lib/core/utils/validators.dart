class Validators {
  static String? requiredField(String? v, {String name = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$name is required';
    return null;
  }

  static String? nic(String? v) {
    final val = (v ?? '').trim();
    if (val.isEmpty) return 'NIC is required';
    final reg = RegExp(r'^(\d{9}[vVxX]|\d{12})$');
    if (!reg.hasMatch(val)) return 'Enter a valid NIC';
    return null;
  }

  static String? phoneLK(String? v) {
    final val = (v ?? '').replaceAll(' ', '').trim();
    if (val.isEmpty) return 'Phone number is required';

    final reg = RegExp(r'^(?:\+94|94|0)?7\d{8}$');
    if (!reg.hasMatch(val)) return 'Enter a valid Sri Lankan mobile number';

    return null;
  }

  static String? email(String? v) {
    final val = (v ?? '').trim();
    if (val.isEmpty) return null;
    final reg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!reg.hasMatch(val)) return 'Enter a valid email';
    return null;
  }

  static String? emailOptional(String? v) => email(v);

  static String? min8Password(String? v) {
    final val = (v ?? '');
    if (val.isEmpty) return 'Password is required';
    if (val.length < 8) return 'Minimum 8 characters';
    return null;
  }

  static String? strongPassword(String? v) {
    if (v == null || v.isEmpty) return "Password is required";
    if (v.length < 8) return "Minimum 8 characters required";

    final hasUpper = RegExp(r'[A-Z]').hasMatch(v);
    final hasNumber = RegExp(r'[0-9]').hasMatch(v);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v);

    if (!hasUpper) return "Must contain at least one uppercase letter";
    if (!hasNumber && !hasSpecial)
      return "Must contain a number or special character";
    return null;
  }
}

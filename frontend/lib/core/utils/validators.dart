class Validators {
  static String? required(String? value, [String field = 'Field ini']) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Email tidak valid';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'No. telepon wajib diisi';
    final regex = RegExp(r'^[0-9]{10,15}$');
    if (!regex.hasMatch(value)) return 'No. telepon tidak valid';
    return null;
  }

  static String? nip(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIP wajib diisi';
    if (value.length < 8) return 'NIP minimal 8 karakter';
    return null;
  }

  static String? nik(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIK wajib diisi';
    if (value.length != 16) return 'NIK harus 16 digit';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password wajib diisi';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Konfirmasi password wajib diisi';
    if (value != password) return 'Password tidak cocok';
    return null;
  }
}

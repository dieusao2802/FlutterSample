class ValidationUtils {
  // Regex kiểm tra email
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Valid email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Email không đúng định dạng';
    }
    return null;
  }

  // Valid mật khẩu (Tối thiểu 6 ký tự)
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  // Valid tên người dùng (Không trống)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên không được để trống';
    }
    if (value.length < 2) {
      return 'Tên quá ngắn';
    }
    return null;
  }
}

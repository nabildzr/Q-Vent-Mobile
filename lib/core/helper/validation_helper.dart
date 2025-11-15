class ValidationHelper {
  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  // Phone number validation (Indonesia format)
  static bool isValidPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check for Indonesian phone number patterns
    // Format: 08xxxxxxxx, +628xxxxxxxx, 628xxxxxxxx
    final phoneRegex = RegExp(r'^(8|08|628|\+628)[0-9]{8,12}$');

    return phoneRegex.hasMatch(cleanPhone) &&
        cleanPhone.length >= 10 &&
        cleanPhone.length <= 15;
  }

  // Format phone number to standard format
  static String formatPhoneNumber(String phoneNumber) {
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Convert to +62 format
    if (cleanPhone.startsWith('08')) {
      cleanPhone = '628${cleanPhone.substring(2)}';
    } else if (cleanPhone.startsWith('8')) {
      cleanPhone = '62$cleanPhone';
    }

    return cleanPhone;
  }

  // Email validation message
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Phone validation message
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(phoneNumber)) {
      return 'Please enter a valid Indonesian phone number';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters';
    } else {
      return null;
    }
  }
}

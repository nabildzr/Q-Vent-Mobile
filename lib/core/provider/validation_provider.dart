import 'package:flutter/material.dart';
import '../helper/validation_helper.dart';

class ValidationProvider extends ChangeNotifier {
  // Error states
  String? _emailError;
  String? _passwordError;
  String? _phoneError;

  // Getters
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get phoneError => _phoneError;

  // Check if form is valid
  bool get isFormValid =>
      _emailError == null && _passwordError == null && _phoneError == null;

  // Validate email
  void validateEmail(String email) {
    _emailError = ValidationHelper.validateEmail(email);
    notifyListeners();
  }

  // Validate password
  void validatePassword(String password) {
    _passwordError = ValidationHelper.validatePassword(password);
    notifyListeners();
  }

  // Validate phone number
  void validatePhoneNumber(String phoneNumber) {
    _phoneError = ValidationHelper.validatePhoneNumber(phoneNumber);
    notifyListeners();
  }

  // Clear all errors
  void clearErrors() {
    _emailError = null;
    _passwordError = null;
    _phoneError = null;
    notifyListeners();
  }

  // Clear specific error
  void clearEmailError() {
    _emailError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    _passwordError = null;
    notifyListeners();
  }

  void clearPhoneError() {
    _phoneError = null;
    notifyListeners();
  }
}

import 'package:equatable/equatable.dart';

class ErrorEntity extends Equatable {
  final String error;
  final Map<String, List<String>> details;

  const ErrorEntity({required this.error, required this.details});

  List<String> get currentPasswordErrors => details['current_password'] ?? [];

  List<String> get newPasswordErrors => details['new_password'] ?? [];

  List<String> get newPasswordConfirmationErrors =>
      details['new_password_confirmation'] ?? [];

  // helper
  String getFirstErrorFor(String field) =>
      details[field]?.isNotEmpty == true ? details[field]!.first : '';

  @override
  List<Object?> get props => [error, details];
}

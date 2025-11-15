import 'package:flutter/material.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/error/clean_error_message_cleaner.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/model/error_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final ChangePasswordUsecase changePasswordUsecase;

  ChangePasswordProvider({required this.changePasswordUsecase});

  String? _errorMessage;
  String? _message;
  ErrorEntity? _errorEntity;

  String? get cleanErrorMessage => _errorMessage.cleanErrorMessage;
  String? get message => _message;
  ResponseStatus _changePasswordStatus = ResponseStatus.initial;

  ResponseStatus get changePasswordStatus => _changePasswordStatus;

  ErrorEntity? get errorEntity => _errorEntity;

  // validation getters
  List<String> get currentPasswordErrors =>
      _errorEntity?.currentPasswordErrors ?? [];
  List<String> get newPasswordErrors => _errorEntity?.newPasswordErrors ?? [];
  List<String> get newPasswordConfirmationErrors =>
      _errorEntity?.newPasswordConfirmationErrors ?? [];

  void _setChangePasswordStatus(ResponseStatus status) {
    _changePasswordStatus = status;
    notifyListeners();
  }

  Future<void> changePassword({
    required String token,
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    _setChangePasswordStatus(ResponseStatus.loading);
    _errorEntity = null;

    final result = await changePasswordUsecase.execute(
      token: token,
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    result.fold(
      (failure) {
        _message = failure.message;

        if (failure is ValidationFailure) {
          _errorEntity = failure.errorEntity;
        }

        print('from cp provider left: ${failure.message}');
        _setChangePasswordStatus(ResponseStatus.error);
      },
      (message) {
        _message = message;
        print('from cp provider right: ${_message}');
        _setChangePasswordStatus(ResponseStatus.success);
      },
    );
  }

  void resetAllStatus() {
    _changePasswordStatus = ResponseStatus.initial;
    notifyListeners();
  }

  String getFormattedErrors() {
    if (_errorEntity == null) return '';

    List<String> errors = [];

    if (currentPasswordErrors.isNotEmpty) {
      errors.add("Current password: ${currentPasswordErrors.join(', ')}");
    }

    if (newPasswordErrors.isNotEmpty) {
      errors.add("New password: ${newPasswordErrors.join(', ')}");
    }

    if (newPasswordConfirmationErrors.isNotEmpty) {
      errors.add("Confirmation: ${newPasswordConfirmationErrors.join(', ')}");
    }

    return errors.join('\n');
  }
}

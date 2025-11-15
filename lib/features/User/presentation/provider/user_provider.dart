import 'package:flutter/material.dart';
import '../../../../core/constant/enum_status.dart';
import '../../../../core/error/clean_error_message_cleaner.dart';
import '../../domain/entities/user_entity.dart';

import '../../domain/usecases/edit_profile_usecase.dart';

class UserProvider extends ChangeNotifier {
  final EditProfileUsecase editProfileUsecase;

  UserProvider({required this.editProfileUsecase});

  String? _errorMessage;
  UserEntity? _userProfile;

  ResponseStatus _editProfileStatus = ResponseStatus.initial;

  String? get errorMessage => _errorMessage.cleanErrorMessage;
  UserEntity? get userProfile => _userProfile;
  ResponseStatus get editProfileStatus => _editProfileStatus;

  void _setEditProfileStatus(ResponseStatus status) {
    _editProfileStatus = status;
    notifyListeners();
  }

  void resetAllStatus() {
    _editProfileStatus = ResponseStatus.initial;
    notifyListeners();
  }

  Future<void> editProfile({
    required String token,
    required String newName,
    required String newPhoneNumber,
  }) async {
    _setEditProfileStatus(ResponseStatus.loading);

    final result = await editProfileUsecase.execute(
      token: token,
      newName: newName,
      newPhoneNumber: newPhoneNumber,
    );

    result.fold(
      (failure) {
        print('from folding - provider - editProfile: ${failure.message}');
        _errorMessage = failure.message;
        _setEditProfileStatus(ResponseStatus.error);
      },
      (user) {
        _userProfile = user;
        _setEditProfileStatus(ResponseStatus.success);
      },
    );
  }
}

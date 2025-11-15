import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/change_password_in_profile_repository.dart';

class ChangePasswordUsecase {
  final ChangePasswordInProfileRepository changePasswordInProfileRepository;

  ChangePasswordUsecase(this.changePasswordInProfileRepository);

  Future<Either<Failure, String>> execute( {
    required String token,
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await changePasswordInProfileRepository.changePassword(
      token,
      userId,
      currentPassword,
      newPassword,
      newPasswordConfirmation,
    );
  }
}

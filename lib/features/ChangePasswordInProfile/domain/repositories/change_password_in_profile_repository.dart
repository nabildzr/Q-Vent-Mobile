import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class ChangePasswordInProfileRepository {
  Future<Either<Failure, String>> changePassword(
     String token,
     int userId,
     String currentPassword,
     String newPassword,
     String newPasswordConfirmation,
  );
}

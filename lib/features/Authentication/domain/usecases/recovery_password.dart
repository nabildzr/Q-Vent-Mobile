import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/recovery_password.dart';
import '../repositories/authentication_repository.dart';

class RecoveryPassword {
  final AuthenticationRepository authenticationRepository;

  RecoveryPassword(this.authenticationRepository);

  Future<Either<Failure, RecoveryPasswordEntity>> execute(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String newPassword,
    String newPasswordConfirmation
  ) async {
    return await authenticationRepository.recoveryPassword(
      isWithEmail,
      phoneNumber,
      email,
      newPassword,
      newPasswordConfirmation,
    );
  }
}

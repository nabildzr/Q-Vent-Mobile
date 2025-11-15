import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/forgot_password.dart';
import '../repositories/authentication_repository.dart';

class ForgotPassword {
  final AuthenticationRepository authenticationRepository;

  const ForgotPassword(this.authenticationRepository);

  Future<Either<Failure, ForgotPasswordEntities>> execute(
    isWithEmail,
    phoneNumber,
    email,
  ) async {
    return await authenticationRepository.forgotPassword(
      isWithEmail,
      phoneNumber,
      email,
    );
  }
}

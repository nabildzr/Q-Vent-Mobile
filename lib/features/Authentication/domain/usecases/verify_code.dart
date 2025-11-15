import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/verify_code.dart';
import '../repositories/authentication_repository.dart';

class VerifyCode {
  final AuthenticationRepository authenticationRepository;

  VerifyCode(this.authenticationRepository);

  Future<Either<Failure, VerifyCodeEntities>> execute(
    isWithEmail,
    phoneNumber,
    email,
    otp,
  ) async {
    return await authenticationRepository.verifyCode(
      isWithEmail,
      phoneNumber,
      email,
      otp,
    );
  }
}

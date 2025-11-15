import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authorization_entity.dart';
import '../entities/forgot_password.dart';
import '../entities/recovery_password.dart';
import '../entities/user.dart';
import '../entities/verify_code.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, AuthorizationEntity>> signIn(String email, String password);
  Future<Either<Failure, ForgotPasswordEntities>> forgotPassword(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
  );
  Future<Either<Failure, VerifyCodeEntities>> verifyCode(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String otp,
  );

  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, User>> getUserFromApi(String token);
  Future<Either<Failure, RecoveryPasswordEntity>> recoveryPassword(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String newPassword,
    String newPasswordConfirmation
  );

  Future<Either<Failure, AuthorizationEntity>> getAuthorization();

  Future<Either<Failure, AuthorizationEntity>> refreshToken(String token);

  Future<Either<Failure, bool>> logout();
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authorization_entity.dart';
import '../repositories/authentication_repository.dart';

class SignIn {
  final AuthenticationRepository authenticationRepository;

  const SignIn(this.authenticationRepository);

  Future<Either<Failure, AuthorizationEntity>> execute(String email, String password) async {
    return await authenticationRepository.signIn(email, password);
  }
}

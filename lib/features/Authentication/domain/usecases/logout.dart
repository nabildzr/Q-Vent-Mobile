import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/authentication_repository.dart';

class Logout {
  final AuthenticationRepository authenticationRepository;

  const Logout(this.authenticationRepository);

  Future<Either<Failure, bool>> execute() {
    return authenticationRepository.logout();
  }
}

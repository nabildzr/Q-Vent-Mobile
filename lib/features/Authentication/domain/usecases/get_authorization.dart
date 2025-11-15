import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/authorization_entity.dart';
import '../repositories/authentication_repository.dart';

class GetAuthorization {
  final AuthenticationRepository authenticationRepository;

  GetAuthorization(this.authenticationRepository);

  Future<Either<Failure, AuthorizationEntity>> execute() {
    return authenticationRepository.getAuthorization();
  }
}

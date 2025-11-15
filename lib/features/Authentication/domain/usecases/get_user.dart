import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class GetUser {
  final AuthenticationRepository authenticationRepository;

  GetUser(this.authenticationRepository);

  Future<Either<Failure, User>> execute() async {
    return await authenticationRepository.getUser();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class GetUserFromApi {
  final AuthenticationRepository authenticationRepository;

  GetUserFromApi(this.authenticationRepository);

  Future<Either<Failure, User>> execute(String token) async {
    return await authenticationRepository.getUserFromApi(token);
  }
}

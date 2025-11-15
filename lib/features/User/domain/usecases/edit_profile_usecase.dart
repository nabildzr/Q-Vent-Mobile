import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class EditProfileUsecase {
  final UserRepository userRepository;
  EditProfileUsecase(this.userRepository);

  Future<Either<Failure, UserEntity>> execute({
    required String token,
    required String? newName,
    required String? newPhoneNumber,
  }) async {
    return await userRepository.editProfile(
      token: token,
      newName: newName,
      newPhoneNumber: newPhoneNumber,
    );
  }
}

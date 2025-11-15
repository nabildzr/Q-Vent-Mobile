import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImplementation implements UserRepository {
  final SharedPreferences sharedPreferences;
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImplementation({
    required this.sharedPreferences,
    required this.userRemoteDatasource,
  });

  @override
  Future<Either<Failure, UserEntity>> editProfile({
    required String token,
    required String? newName,
    required String? newPhoneNumber,
  }) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        print('from repo impl - edit profile: no connection');

        return Left(ConnectionFailure('No internet connection'));
      } else {
        final result = await userRemoteDatasource.editProfile(
          token: token,
          newName: newName,
          newPhoneNumber: newPhoneNumber,
        );

        print('from repo impl right - edit profile: $result');

        return Right(result);
      }
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../datasources/change_password_remote_datasource.dart';
import '../../domain/repositories/change_password_in_profile_repository.dart';

class ChangePasswordInProfileRepositoryImplementation
    implements ChangePasswordInProfileRepository {
  final ChangePasswordRemoteDatasource changePasswordRemoteDatasource;

  ChangePasswordInProfileRepositoryImplementation({
    required this.changePasswordRemoteDatasource,
  });

  @override
  Future<Either<Failure, String>> changePassword(
    token,
    userId,
    currentPassword,
    newPassword,
    newPasswordConfirmation,
  ) async {
    try {
      final List<ConnectivityResult> _connectivityResult =
          await (Connectivity().checkConnectivity());

      if (_connectivityResult.contains(ConnectivityResult.none)) {
        print('from change-password: No Connection');
        return Left(ConnectionFailure('No Connection available.'));
      } else {
        final result = await changePasswordRemoteDatasource.changePassword(
          token: token,
          userId: userId,
          currentPassword: currentPassword,
          newPassword: newPassword,
          newPasswordConfirmation: newPasswordConfirmation,
        );

        print('from change-password result: $result');

        return Right(result);
      }
    } on ValidationException catch (e) {
      String errorMessage = "Validation failed";

      if (e.errorEntity.newPasswordErrors.isNotEmpty) {
        errorMessage = e.errorEntity.newPasswordErrors.join('. ');
      }

      return Left(ValidationFailure(errorMessage, e.errorEntity));
    } catch (e) {
      print("from change-password repo impl: $e");
      return Left(GeneralFailure(e.toString()));
    }
  }
}

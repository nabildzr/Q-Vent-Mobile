import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/model/error_model.dart';

abstract class ChangePasswordRemoteDatasource {
  Future<String> changePassword({
    required String token,
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}

class ChangePasswordRemoteDataSourceImplementation
    implements ChangePasswordRemoteDatasource {
  final http.Client client;

  ChangePasswordRemoteDataSourceImplementation({required this.client});

  @override
  Future<String> changePassword({
    required String token,
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await client.put(
      Uri.parse(Constant.endpoint('/user/$userId/change-password')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );

    print('from change-password response: $response');

    final Map<String, dynamic> body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return body['message'] ?? 'Password changed successfully';
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print('from change-password validation: $body');

      final errorEntity = ErrorModel(
        error: body['error'] ?? 'Validation failed',
        details: _parseErrorDetails(body['details']),
      );

      throw ValidationException(errorEntity: errorEntity);
    } else {
      print('from change-password error: $body');
      throw GeneralException(message: body['details'] ?? 'Unknown error');
    }
  }

  Map<String, List<String>> _parseErrorDetails(dynamic details) {
    if (details == null) return {};

    final Map<String, List<String>> result = {};

    if (details is Map<String, dynamic>) {
      details.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => e.toString()).toList();
        } else if (value is String) {
          result[key] = [value];
        }
      });
    }

    return result;
  }
}

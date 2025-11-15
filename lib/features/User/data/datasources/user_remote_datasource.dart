import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';


abstract class UserRemoteDatasource {
  Future<UserModel> editProfile({
    required String token,
    required String? newName,
    required String? newPhoneNumber,
  });
}

class UserRemoteDatasourceImplementation implements UserRemoteDatasource {
  final http.Client client;

  UserRemoteDatasourceImplementation({required this.client});

  @override
  Future<UserModel> editProfile({
    required String token,
    required String? newName,
    required String? newPhoneNumber,
  }) async {
    try {
      final response = await client.patch(
        Uri.parse(Constant.endpoint('/user/edit-profile')),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          if (newName != null) 'name': newName,
          if (newPhoneNumber != null) 'phone_number': newPhoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);

        print('from remote datasource - edit profile: $body');

        return UserModel.fromJson(body['user']);
      } else {
        Map<String, dynamic> body = jsonDecode(response.body);
        print('error from server: $body');
        throw ServerException(message: "Server Error");
      }
    } catch (e) {
      print('from user remote datasource - edit profile: $e');
      throw GeneralException(message: "Something went wrong.");
    }
  }
}

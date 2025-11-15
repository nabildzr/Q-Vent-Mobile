import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../models/authorization_model.dart';
import '../models/forgot_password_model.dart';
import '../models/recovery_password.dart';
import '../models/user_model.dart';
import '../models/verify_code_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<AuthorizationModel> signIn(String email, String password);
  Future<ForgotPasswordModel> forgotPassword(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
  );
  Future<VerifyCodeModel> verifyCode(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String otp,
  );
  Future<RecoveryPasswordModel> recoveryPassword(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String newPassword,
    String newPasswordConfirmation,
  );

  Future<void> logout(String token);

  Future<UserModel> getUserFromApi(String token);

  Future<AuthorizationModel> refreshToken(String token);
}

class AuthenticationRemoteDataSourceImplementation
    extends AuthenticationRemoteDataSource {
  final http.Client client;

  AuthenticationRemoteDataSourceImplementation({required this.client});

  @override
  Future<AuthorizationModel> signIn(email, password) async {
    final response = await client.post(
      Uri.parse(Constant.endpoint("/user/sign-in")),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    print(response.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);

      // String token = dataBody['token'];
      // String expiresAt = dataBody['expires_at'];

      print(
        'Complete user data with token (Add token and expires_at into userData object), result: $dataBody',
      );

      return AuthorizationModel.fromJson(dataBody);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      throw EmptyException(message: data['message']);
    } else {
      print("error");

      throw GeneralException(message: "Server Error");
    }
  }

  @override
  Future<ForgotPasswordModel> forgotPassword(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
  ) async {
    final response = await client.post(
      Uri.parse(Constant.endpoint("/user/send-code")),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "isWithEmail": isWithEmail,
        if (isWithEmail) "email": email else "phone_number": phoneNumber,
      }),
    );

    print("request: em: $email, ph: $phoneNumber, isWE: $isWithEmail");

    print(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);

      print("result: $dataBody");

      return ForgotPasswordModel.fromJson(dataBody);
    } else if (response.statusCode == 404 || response.statusCode == 400) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);

      throw EmptyException(message: dataBody['message']);
    } else {
      throw GeneralException(message: 'Cannot get data');
    }
  }

  @override
  Future<VerifyCodeModel> verifyCode(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String otp,
  ) async {
    final response = await client.post(
      Uri.parse(Constant.endpoint('/user/verify-code')),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "isWithEmail": isWithEmail,
        "otp": otp,
        if (isWithEmail) "email": email else "phone_number": phoneNumber,
      }),
    );

    print("verify-code-response: $response");

    if (response.statusCode == 200) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);

      print("verify-code-data-result: $dataBody");

      return VerifyCodeModel(message: dataBody['message']);
    } else if (response.statusCode == 404 || response.statusCode == 400) {
      Map<String, dynamic> dataBody = jsonDecode(response.body);

      print("verify-code-exception-result: $dataBody");

      throw EmptyException(message: dataBody['message']);
    } else {
      throw GeneralException(message: "Cannot get data");
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      final response = await client.post(
        Uri.parse(Constant.endpoint('/user/sign-out')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // print(response);
      // print("Logout response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        // print('Logout successful on server');
      } else {
        // print('Logout failed on server, but will clear local data anywayy');
      }
    } catch (e) {
      // print('Logout API Error: $e');
      throw GeneralException(message: "Cannot get data");
    }
  }

  @override
  Future<RecoveryPasswordModel> recoveryPassword(
    bool isWithEmail,
    String? phoneNumber,
    String? email,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    try {
      final response = await client.put(
        Uri.parse(Constant.endpoint('/user/recovery-password')),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode({
          "isWithEmail": isWithEmail,
          "new_password": newPassword,
          "new_password_confirmation": newPasswordConfirmation,
          if (isWithEmail) "email": email else "phone_number": phoneNumber,
        }),
      );
      Map<String, dynamic> dataBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return RecoveryPasswordModel.fromJson(dataBody);
      } else if (response.statusCode == 404) {
        // print('from-recovery-password 404: ${dataBody['message']}');
        throw EmptyException(message: dataBody['message']);
      } else {
        // print('from-recovery-password general error: ${dataBody['message']}');
        throw GeneralException(
          message: "Cannot Recovery Password, Server Error",
        );
      }
    } catch (e) {
      print('Recovery Password API Error: $e');

      throw GeneralException(
        message: "Cannot Recovery Password ${e.toString()}",
      );
    }
  }

  @override
  Future<UserModel> getUserFromApi(String token) async {
    try {
      final response = await client.get(
        Uri.parse(Constant.endpoint('/user')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = jsonDecode(response.body);
        return UserModel.fromJson(userData);
      } else if (response.statusCode == 404 || response.statusCode == 401) {
        Map<String, dynamic> data = jsonDecode(response.body);
        throw EmptyException(message: data['message']);
      } else {
        throw GeneralException(message: "Server Error");
      }
    } catch (e) {
      print('from profile data : $e');
      throw GeneralException(message: "Cannot get user data:");
    }
  }

  @override
  Future<AuthorizationModel> refreshToken(String token) async {
    try {
      final response = await client.get(
        Uri.parse(Constant.endpoint('/user/refresh-token')),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        print('from refresh-token auth remote-datasource: success refreshed');

        Map<String, dynamic> body = jsonDecode(response.body);

        return AuthorizationModel.fromJson(body);
      } else {
        print('from refresh-token auth remote-datasource: logout failed on server, but will clear local data anywayy');
        throw ServerException(message: 'Something went happen');
      }
    } catch (e) {
      throw GeneralException(message: e.toString());
    }
  }
}

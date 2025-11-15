import '../../domain/entities/authorization_entity.dart';

class AuthorizationModel extends AuthorizationEntity {
  const AuthorizationModel({required super.token, required super.expiresAt});

  factory AuthorizationModel.fromJson(Map<String, dynamic> data) {
    return AuthorizationModel(
      token: data['token'] ?? '',
      expiresAt: data['expires_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expires_at': expiresAt
    };
  }
}

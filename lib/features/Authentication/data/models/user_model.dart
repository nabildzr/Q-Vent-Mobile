import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.role,
    required super.phoneNumber,
    required super.expiresAt,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id']  ?? 0,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      token: data['token'] ?? '',
      expiresAt: data['expires_at'] ?? '',
    );
  }

  // convert model ke json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'phone_number': phoneNumber,
      'role': role,
      'token': token,
      'expires_at': expiresAt
    };
  }
}

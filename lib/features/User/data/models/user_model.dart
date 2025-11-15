import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.role,
    required super.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
      role: data['role'],
      phoneNumber: data['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'phone_number': phoneNumber,
      'role': role,
    };
  }
}

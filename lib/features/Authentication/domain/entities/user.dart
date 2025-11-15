import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;
  final String role;
  final String token;
  final String expiresAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.phoneNumber,
    required this.token,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    createdAt,
    updatedAt,
    role,
    phoneNumber,
    token,
    expiresAt,
  ];
}

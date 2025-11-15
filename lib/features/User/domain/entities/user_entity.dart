import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String createdAt;
  final String updatedAt;
  final String role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.phoneNumber,
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
  ];
}

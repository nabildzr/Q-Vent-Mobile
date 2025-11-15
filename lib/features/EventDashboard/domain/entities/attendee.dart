import 'package:equatable/equatable.dart';

class AttendeeEntity extends Equatable {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String code;
  final String createdAt;
  final String updatedAt;

  const AttendeeEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    phoneNumber,
    email,
    code,
    createdAt,
    updatedAt,
  ];
}

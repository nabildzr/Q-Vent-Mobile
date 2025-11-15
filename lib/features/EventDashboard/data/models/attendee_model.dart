import '../../domain/entities/attendee.dart';

class AttendeeModel extends AttendeeEntity {
  const AttendeeModel({
    required super.id,
    required super.phoneNumber,
    required super.email,
    required super.code,
    required super.createdAt,
    required super.updatedAt,
    required super.fullName,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return AttendeeModel(
        id: 0,
        fullName: '',
        phoneNumber: '',
        email: '',
        code: '',
        createdAt: '',
        updatedAt: '',
      );
    }

    // Combine first_name and last_name for fullName
    String firstName = data['first_name'] ?? '';
    String lastName = data['last_name'] ?? '';
    String fullName = '$firstName $lastName'.trim();

    return AttendeeModel(
      id: data['id'] ?? 0,
      fullName: fullName,
      phoneNumber: data['phone_number'] ?? '',
      email: data['email'] ?? '',
      code: data['code'] ?? '',
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'email': email,
      'code': code,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

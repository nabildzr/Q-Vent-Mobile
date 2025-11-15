import 'package:intl/intl.dart';
import '../../domain/entities/attendance.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.id,
    required super.status,
    required super.checkInTime,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.checkInDate,
    required super.checkInDateTime,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['id'],
      status: data['status'] ?? '',
      checkInTime: data['check_in_time'] != null ? 
          DateFormat('HH:mm').format(DateTime.parse(data['check_in_time'])) : '',
      checkInDate: data['check_in_time'] != null ? 
          DateFormat('MMMM dd, yyyy').format(DateTime.parse(data['check_in_time'])) : '',
      checkInDateTime: data['check_in_time'] ?? '',
      notes: data['notes'] ?? '',
      createdAt: data['created_at'] ?? '',
      updatedAt: data['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'check_in_time': checkInTime,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

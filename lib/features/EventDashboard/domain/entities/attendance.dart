import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final int id;
  final String status;
  final String checkInTime;
  final String checkInDate;
  final String checkInDateTime;
  final String notes;
  final String createdAt;
  final String updatedAt;

  const AttendanceEntity({
    required this.id,
    required this.status,
    required this.checkInTime,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.checkInDate,
    required this.checkInDateTime,
  });

  @override
  List<Object?> get props => [
    id,
    status,
    checkInTime,
    notes,
    createdAt,
    updatedAt,
  ];
}

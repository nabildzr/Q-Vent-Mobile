import 'package:intl/intl.dart';

import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.eventCategory,
    required super.createdBy,
    required super.status,
    required super.startDate,
    required super.endDate,
    required super.banner,
    required super.createdAt,
    required super.attendancePercentage,
    required super.attendeeCount,
    required super.presentOrLateCount,
    required super.absentCount,
    required super.rawStartDate,
    required super.rawEndDate,
    required super.isOngoing,
  });

  factory EventModel.fromJson(Map<String, dynamic> data) {
    return EventModel(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      eventCategory: data['event_category']?['name'] ?? '',
      createdBy: data['created_by']?['name'] ?? '',
      status: data['status'] ?? '',
      rawStartDate: data['start_date'] ?? '',
      rawEndDate: data['end_date'] ?? '',

      startDate:
          data['start_date'] != null
              ? DateFormat(
                'd MMMM yyyy HH:mm',
              ).format(DateTime.parse(data['start_date']))
              : '',
      endDate:
          data['end_date'] != null
              ? DateFormat(
                'd MMMM yyyy HH:mm',
              ).format(DateTime.parse(data['end_date']))
              : '',
      banner: data['banner'] ?? '',
      createdAt: data['created_at'] ?? '',
      attendancePercentage: data['attendance_percentage'] ?? 0,
      attendeeCount: data['attendee_count'] ?? 0,
      presentOrLateCount: data['present_or_late_count'] ?? 0,
      absentCount: data['absent_count'] ?? 0,
      isOngoing: _isEventOngoing(
        data['start_date'] ?? '',
        data['end_date'] ?? '',
        data['status'] ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_category': {'name': eventCategory},
      'created_by': {'name': createdBy},
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'banner': banner,
      'created_at': createdAt,
      'attendance_percentage': attendancePercentage,
      'present_or_late_count': presentOrLateCount,
      'absent_count': absentCount,
    };
  }

  static bool _isEventOngoing(String startDate, String endDate, String status) {
    try {
      final now = DateTime.now();
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      // The event is ongoing if:
      // - status is 'active'
      // - start_date <= now
      // - end_date >= now
      // This logic matches the provided query.
      return status == 'active' &&
          !now.isBefore(DateTime(start.year, start.month, start.day)) &&
          !now.isAfter(DateTime(end.year, end.month, end.day, 23, 59, 59));
    } catch (e) {
      print("Error parsing dates: $e");
      return false;
    }
  }
}

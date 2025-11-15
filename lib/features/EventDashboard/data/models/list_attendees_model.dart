import 'attendee_with_attendance_model.dart';
import '../../domain/entities/list_attendees_entity.dart';

class ListAttendeesModel extends ListAttendeesEntity {
  const ListAttendeesModel({
    required super.attendeeWithAttendance,
    required super.success,
  });

  factory ListAttendeesModel.fromJson(Map<String, dynamic> data) {
    return ListAttendeesModel(
      attendeeWithAttendance: AttendeeWithAttendanceModel.fromJsonList(
        data['data']['attendees'],
      ),
      success: data['success'],
    );
  }

  static List<ListAttendeesModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    return data
        .map((singleAttendee) => ListAttendeesModel.fromJson(singleAttendee))
        .toList();
  }
}

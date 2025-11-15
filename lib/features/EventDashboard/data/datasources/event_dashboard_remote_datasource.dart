import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qr_event_management/features/EventDashboard/data/models/check_identity_model.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../models/attendance_data_model.dart';
import '../models/event_model.dart';
import '../models/list_attendees_model.dart';

abstract class EventDashboardRemoteDatasource {
  Future<EventModel> getEventById(token, eventId);
  Future<AttendanceDataModel> scanAttendance(token, eventId, code);
  Future<CheckIdentityModel> scanIdentityCheck(token, eventId, code);
  Future<ListAttendeesModel> getEventAttendees(token, eventId);

  Future<bool> updateAttendeesStatus(
  token,
  eventId,
    List<Map<String, dynamic>> attendeesData,
  );
}

class EventDashboardRemoteDatasourceImplementation
    implements EventDashboardRemoteDatasource {
  final http.Client client;

  EventDashboardRemoteDatasourceImplementation({required this.client});

  @override
  Future<EventModel> getEventById(token, eventId) async {
    final response = await client.get(
      Uri.parse(Constant.endpoint('/event/$eventId')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // print('from event dashboard response: ${jsonEncode(response)}');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      print('from event dashboard body: $data');

      return EventModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw GeneralException(message: 'Event not found');
    } else {
      Map<String, dynamic> e = jsonDecode(response.body);
      print('from event dashboard error: $e');
      throw GeneralException(message: 'Something Error');
    }
  }

  @override
  Future<AttendanceDataModel> scanAttendance(token, eventId, code) async {
    final response = await client.post(
      Uri.parse(Constant.endpoint('/event/$eventId/scan-attendance')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'qrcode_data': code}),
    );

    print(
      'from event dashboard - remote datasource - scan-attendance: ${response.body}',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      print(body);

      return AttendanceDataModel.fromJson(body);
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);

      print(
        "from event dashboard - remote datasource - scan-attendance - statusCode 400: $body",
      );

      throw GeneralException(message: body['message']);
    } else if (response.statusCode == 500) {
      final body = jsonDecode(response.body);

      print(body);

      throw GeneralException(message: body['message']);
    } else {
      final body = jsonDecode(response.body);

      print(body);

      print(
        'from event dashboard - remote datasource - scan-attendance err 500: $body',
      );

      throw ServerException(message: "Server Error");
    }
  }

  @override
  Future<CheckIdentityModel> scanIdentityCheck(token, eventId, code) async {
    final response = await client.post(
      Uri.parse(Constant.endpoint('/event/$eventId/scan-identity')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'qrcode_data': code}),
    );

    print(
      'from event dashboard - remote datasource - scan-identity-check: $response',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      print(body);

      return CheckIdentityModel.fromJson(body);
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);

      print(body);

      throw GeneralException(message: body['message']);
    } else if (response.statusCode == 500) {
      final body = jsonDecode(response.body);

      print(body);

      throw GeneralException(message: body['message']);
    } else {
      final body = jsonDecode(response.body);

      print(body);

      print(
        'from event dashboard - remote datasource - scan-identity-check err 500: $body',
      );

      throw ServerException(message: "Server Error");
    }
  }

  @override
  Future<ListAttendeesModel> getEventAttendees(token, eventId) async {
    final response = await client.get(
      Uri.parse(Constant.endpoint('/event/$eventId/attendees')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(
      'from event dashboard - remote datasource - get-event-attendees: ${response.body}',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      print(body);

      return ListAttendeesModel.fromJson(body);
    } else if (response.statusCode == 400) {
      final body = jsonDecode(response.body);

      print(body);

      throw GeneralException(message: body['message']);
    } else if (response.statusCode == 500) {
      final body = jsonDecode(response.body);

      print(body);

      throw GeneralException(message: body['message']);
    } else {
      final body = jsonDecode(response.body);

      print(body);

      print(
        'from event dashboard - remote datasource - get-event-attendees err 500: $body',
      );

      throw ServerException(message: "Server Error");
    }
  }

  @override
  Future<bool> updateAttendeesStatus(
  token,
    eventId,
    List<Map<String, dynamic>> attendeesData,
  ) async {
    final response = await client.post(
      Uri.parse(Constant.endpoint('/event/$eventId/update-attendees')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'attendees': attendeesData}),
    );

    print('Event dashboard - update attendees response: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['success'] ?? false;
    } else {
      final body = jsonDecode(response.body);
      throw GeneralException(
        message: body['message'] ?? 'Failed to update attendees',
      );
    }
  }
}

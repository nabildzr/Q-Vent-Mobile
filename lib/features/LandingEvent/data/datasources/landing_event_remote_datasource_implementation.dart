import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';
import 'landing_event_remote_datasource.dart';

class LandingEventRemoteDatasourceImplementation
    implements LandingEventRemoteDataSource {
  final http.Client client;

  LandingEventRemoteDatasourceImplementation({required this.client});

  @override
  Future<List<EventModel>> getEventOngoing(String token, int userId) async {
    final response = await client.get(
      Uri.parse(Constant.endpoint('/user/$userId/events/ongoing')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      print('from getEventOngoing: $body');
      return EventModel.fromJsonList(body['data']);
    } else if (response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw EmptyException(message: body['message']);
    } else {
      final body = jsonDecode(response.body);
      throw GeneralException(message: body['message']);
    }
  }

  @override
  Future<List<EventModel>> getEventPast(String token, int userId) async {
    final response = await client.get(
      Uri.parse(Constant.endpoint('/user/$userId/events/done')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String,dynamic> body = jsonDecode(response.body);
      print('from getEventPast: $body');
      return EventModel.fromJsonList(body['data']);
    } else if (response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw EmptyException(message: body['message']);
    } else {
      final body = jsonDecode(response.body);
      print('while fetching: $body');

      throw GeneralException(message: "Something Error");
    }
  }

  @override
  Future<List<EventModel>> getEventUpcoming(String token, int userId) async {
    final response = await client.get(
      Uri.parse(Constant.endpoint('/user/$userId/events/upcoming')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      print('from getEventUpcoming: $body');
      return EventModel.fromJsonList(body['data']);
    } else if (response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw EmptyException(message: body['message']);
    } else {
      throw GeneralException(message: "Something Error");
    }
  }
}

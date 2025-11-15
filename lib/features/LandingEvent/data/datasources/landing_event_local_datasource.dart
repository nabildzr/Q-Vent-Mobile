import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';

abstract class LandingEventLocalDatasource {
  Future<List<EventModel>> getEventUpcoming();
  Future<List<EventModel>> getEventOngoing();
  Future<List<EventModel>> getEventPast();
}

class LandingEventLocalDatasourceImplementation
    implements LandingEventLocalDatasource {
  final SharedPreferences sharedPreferences;

  LandingEventLocalDatasourceImplementation({required this.sharedPreferences});

  @override
  Future<List<EventModel>> getEventOngoing() async {
    final jsonString = sharedPreferences.getString(
      'landing_event_ongoing_cache',
    );
    if (jsonString == null) {
      throw GeneralException(message: "Ongoing Event not found");
    }

    return EventModel.fromJsonList(jsonDecode(jsonString));
  }

  @override
  Future<List<EventModel>> getEventPast() async {
    final jsonString = sharedPreferences.getString(
      'landing_event_past_cache',
    );
    if (jsonString == null) {
      throw GeneralException(message: "Past Event not found");
    }

    return EventModel.fromJsonList(jsonDecode(jsonString));
  }

  @override
  Future<List<EventModel>> getEventUpcoming() async {
    final jsonString = sharedPreferences.getString(
      'landing_event_upcoming_cache',
    );
    if (jsonString == null) {
      throw GeneralException(message: "Upcoming Event not found");
    }

    return EventModel.fromJsonList(jsonDecode(jsonString));
  }
}

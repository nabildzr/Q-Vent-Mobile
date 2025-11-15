import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/search_event_model.dart';

abstract class SearchEventsLocalDatasource {
  Future<List<SearchEventModel>> searchEvents();
}

class SearchEventsLocalDatasourceImplementation
    implements SearchEventsLocalDatasource {
  final SharedPreferences sharedPreferences;
  final http.Client client;

  SearchEventsLocalDatasourceImplementation({
    required this.client,
    required this.sharedPreferences,
  });
  @override
  Future<List<SearchEventModel>> searchEvents() async {
    final jsonString = sharedPreferences.getString(
      'search_landing_events_cache',
    );
    if (jsonString == null) {
      print('in search events local data sources, home event history: none');
      throw GeneralException(message: "Events not found");
    }

    return SearchEventModel.fromJsonList(json.decode(jsonString));
  }
}

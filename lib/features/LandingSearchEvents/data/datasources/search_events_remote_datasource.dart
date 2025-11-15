import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../models/search_event_model.dart';

abstract class SearchEventsRemoteDatasource {
  Future<List<SearchEventModel>> searchEvents({
    required String token,
    required int userId,
    required String query,
  });
}

class SearchEventsRemoteDatasourceImplementation
    implements SearchEventsRemoteDatasource {
  final http.Client client;

  SearchEventsRemoteDatasourceImplementation({required this.client});

  @override
  Future<List<SearchEventModel>> searchEvents({
    required String token,
    required int userId,
    required String query,
  }) async {
    final response = await client.get(
      Uri.parse(Constant.endpoint('/user/$userId/events/search?query=$query')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );


    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return SearchEventModel.fromJsonList(data);
    } else if (response.statusCode == 404) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      throw GeneralException(message: data['message']);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      throw GeneralException(message: data['message']);
    } else if (response.statusCode == 500) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      throw ServerException(message: data['message']);
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('error while searching events: ${data}',);
      throw GeneralException(message: 'Something Error');
    }
  }
}

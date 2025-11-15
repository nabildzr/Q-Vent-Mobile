import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constant/constant.dart';
import '../../../../core/error/exceptions.dart';
import '../models/HomeEventHistoryModel.dart';
import '../models/HomeSummaryModel.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDatasourceImplementation extends HomeRemoteDatasource {
  final http.Client client;

  HomeRemoteDatasourceImplementation({required this.client});

  @override
  Future<HomeSummaryModel> getHomeSummary(String token) async {
    try {
      final response = await client.get(
        Uri.parse(Constant.endpoint("/user/events-summary")),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        // print('result body: $data');
        return HomeSummaryModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw StatusCodeException(message: "Data not found - Error");
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        print('server errors: $data');

        throw GeneralException(message: "Cannot get data.");
      }
    } catch (e) {
      print('result error: $e');
      throw GeneralException(message: "Cannot get data");
    }
  }

  @override
  Future<List<HomeEventHistoryModel>> getHomeEventHistory(
    String token,
  ) async {
    try {
      final response = await client.get(
        Uri.parse(Constant.endpoint('/user/events-history')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> dataBody = jsonDecode(response.body);
        // print('result body | event history: $dataBody');
        return HomeEventHistoryModel.fromJsonList(dataBody);
      } else if (response.statusCode == 404) {
        throw EmptyException(message: "Data not found - Error");
      } else {
        throw GeneralException(message: "Connection Failed");
      }
    } catch (e) {
      print('result error while fetching getEventHistory: $e');
      throw GeneralException(message: "Failed to get data");
    }
  }
}

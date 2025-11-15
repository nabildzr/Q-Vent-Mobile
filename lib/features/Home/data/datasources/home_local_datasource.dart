import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/HomeEventHistoryModel.dart';
import '../models/HomeSummaryModel.dart';

abstract class HomeLocalDatasource {
  Future<HomeSummaryModel> getHomeSummary();
  Future<List<HomeEventHistoryModel>> getHomeEventHistory();
}

class HomeLocalDatasourceImplementation extends HomeLocalDatasource {
  final SharedPreferences sharedPreferences;

  HomeLocalDatasourceImplementation({required this.sharedPreferences});

  @override
  Future<HomeSummaryModel> getHomeSummary() async {
    final jsonString = sharedPreferences.getString('home_summary');
    if (jsonString == null)
      throw GeneralException(message: "Home Summary not found");
    return HomeSummaryModel.fromJson(json.decode(jsonString));
  }

  @override
  Future<List<HomeEventHistoryModel>> getHomeEventHistory() async {
    final jsonString = sharedPreferences.getString('home_event_history');
    if (jsonString == null) {
      print('in home event locald data sources, home event history: none');
      throw GeneralException(message: "Home Summary not found");
    }

    return HomeEventHistoryModel.fromJsonList(json.decode(jsonString));
  }

}

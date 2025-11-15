import '../models/HomeEventHistoryModel.dart';
import '../models/HomeSummaryModel.dart';

abstract class HomeRemoteDatasource {
  Future<HomeSummaryModel> getHomeSummary(String token, );
  Future<List<HomeEventHistoryModel>> getHomeEventHistory(String token, );
}
import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/error/clean_error_message_cleaner.dart';
import '../../domain/entities/HomeEventHistoryEntity.dart';
import '../../domain/entities/HomeSummaryEntity.dart';
import '../../domain/usecases/home_event_history_usecase.dart';
import '../../domain/usecases/home_summary_usecase.dart';

enum HomeStatus { initial, loading, success, error }

class HomeProvider extends ChangeNotifier {
  final HomeSummaryUsecase homeSummaryUsecase;
  final HomeEventHistoryUsecase homeEventHistoryUsecase;

  HomeProvider({
    required this.homeSummaryUsecase,
    required this.homeEventHistoryUsecase,
  });

  String? _errorMessage;

  //? HomeSummary
  HomeStatus _homeSummaryStatus = HomeStatus.initial;
  HomeStatus _homeStatus = HomeStatus.initial;
  HomeSummaryEntity? _homeSummary;

  Timer? _autoTimer;
  bool _disposed = false;
  // getter
  HomeStatus get homeSummaryStatus => _homeSummaryStatus;
  HomeStatus get homeStatus => _homeStatus;
  // getter data location
  HomeSummaryEntity? get homeSummary => _homeSummary;

  String get cleanErrorMessage => _errorMessage.cleanErrorMessage;

  // setter
  void _setHomeSummaryStatus(HomeStatus status) {
    _homeSummaryStatus = status;
    notifyListeners();
  }
  void _setHomeStatus(HomeStatus status) {
    _homeStatus = status;
    notifyListeners();
  }

  Future<void> getHomeSummary({
    required String token,
   
  }) async {
  

    final result = await homeSummaryUsecase.execute(token);
    print('from provider: $result');

    result.fold(
      (failure) {
        
        print(
          'error message: ${failure.message}, result: ${result}, all failure: $failure',
        );
        _errorMessage = failure.message;
        _setHomeSummaryStatus(HomeStatus.error);
      },
      (summary) {
        _homeSummary = summary;
        _setHomeSummaryStatus(HomeStatus.success);
      },
    );
  }

  //? HomeEventHistory
  HomeStatus _homeEventHistoryStatus = HomeStatus.initial;
  List<HomeEventHistoryEntity>? _homeEventHistory;

  HomeStatus get homeEventHistoryStatus => _homeEventHistoryStatus;
  List<HomeEventHistoryEntity>? get homeEventHistory => _homeEventHistory;

  void _setHomeEventHistoryStatus(HomeStatus status) {
    _homeEventHistoryStatus = status;
    notifyListeners();
  }

  Future<void> getHomeEventHistory({
    required String token,
   
  }) async {
    try {
      final result = await homeEventHistoryUsecase.execute(token);

      result.fold(
        (failure) {
          print(
            'error message: ${failure.message}, result: ${result}, all failure: $failure',
          );

          _errorMessage = failure.message;
          _setHomeEventHistoryStatus(HomeStatus.error);
        },
        (eventHistory) {
          _homeEventHistory = eventHistory;
          _setHomeEventHistoryStatus(HomeStatus.success);
        },
      );
    } catch (e) {
      _setHomeSummaryStatus(HomeStatus.error);
      _errorMessage = e.toString();
      notifyListeners();

      print('Event history error: $e');
    }
  }

  Future<void> getHomeSummaryRefresh({
    required String token,
   
  }) async {
    _setHomeSummaryStatus(HomeStatus.loading);

    final result = await homeSummaryUsecase.execute(token);
    print('from provider: $result');

    result.fold(
      (failure) {
        print(
          'error message: ${failure.message}, result: ${result}, all failure: $failure',
        );
        _errorMessage = failure.message;
        _setHomeSummaryStatus(HomeStatus.error);
      },
      (summary) {
        _homeSummary = summary;
        _setHomeSummaryStatus(HomeStatus.success);
      },
    );
  }

  Future<void> getHomeEventHistoryRefresh({
    required String token,
   
  }) async {
    try {
      _setHomeEventHistoryStatus(HomeStatus.loading);

      final result = await homeEventHistoryUsecase.execute(token);

      result.fold(
        (failure) {
          print(
            'error message: ${failure.message}, result: ${result}, all failure: $failure',
          );

          _errorMessage = failure.message;
          _setHomeEventHistoryStatus(HomeStatus.error);
        },
        (eventHistory) {
          _homeEventHistory = eventHistory;
          _setHomeEventHistoryStatus(HomeStatus.success);
        },
      );
    } catch (e) {
      _setHomeEventHistoryStatus(HomeStatus.error);
      _errorMessage = e.toString();
      notifyListeners();

      print('Event history error: $e');
    }
  }

  void resetState() {
    _homeEventHistory = null;
    _homeSummary = null;
    _errorMessage = null;
    _homeSummaryStatus = HomeStatus.initial;
    notifyListeners();
  }

  void refreshAutoRefresh({
    required String token,
   
    Duration interval = const Duration(seconds: 5),
  }) {
    stopAutoRefresh();
    startAutoRefresh(interval: interval, token: token);
  }

  
  // start auto refresh setiap interval (default 5 detik)
  void startAutoRefresh({
    Duration interval = const Duration(seconds: 1000),
    required String token,
   
  }) {
    _autoTimer?.cancel();
    // first fetch
    getHomeSummary(token: token);
    getHomeEventHistory(token: token);

    _autoTimer = Timer.periodic(interval, (_) {
      if (_disposed) return;
      getHomeSummary(token: token);
      getHomeEventHistory(token: token);
    });
  }

  void stopAutoRefresh() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  @override
  void dispose() {
    _disposed = true;
    _autoTimer?.cancel();
    super.dispose();
  }
}

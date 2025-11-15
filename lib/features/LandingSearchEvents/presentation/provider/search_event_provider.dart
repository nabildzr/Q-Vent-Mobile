import 'package:flutter/material.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/error/clean_error_message_cleaner.dart';
import '../../domain/entities/search_event_entity.dart';
import '../../domain/usecases/search_events_usecase.dart';

class SearchEventsProvider extends ChangeNotifier {
  final SearchEventsUsecase searchEventUsecase;

  SearchEventsProvider({required this.searchEventUsecase});

  List<SearchEventEntity>? _searchResults;
  String _errorMessage = '';
  ResponseStatus _searchStatus = ResponseStatus.initial;

  // Getters
  List<SearchEventEntity>? get searchResults => _searchResults;
  String get errorMessage => _errorMessage;
  ResponseStatus get searchStatus => _searchStatus;

  String get cleanErrorMessage => _errorMessage.cleanErrorMessage;

  void _setSearchStatus(ResponseStatus status) {
    _searchStatus = status;
    notifyListeners();
  }

  Future<void> searchEvents(
    String query, {
    required String token,
    required int userId,
  }) async {
    _setSearchStatus(ResponseStatus.loading);

    final result = await searchEventUsecase.execute(token, userId, query);

    result.fold(
      (failed) {
        _errorMessage = failed.message;
        _setSearchStatus(ResponseStatus.error);
      },
      (events) {
        _searchResults = events;
        _setSearchStatus(ResponseStatus.success);
      },
    );
  }
}

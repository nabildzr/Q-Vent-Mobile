import 'package:flutter/material.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/error/clean_error_message_cleaner.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/event_ongoing_usecase.dart';
import '../../domain/usecases/event_past_usecase.dart';
import '../../domain/usecases/event_upcoming_usecase.dart';

class LandingEventProvider extends ChangeNotifier {
  final LandingEventUpcomingUsecase landingEventUpcomingUsecase;
  final LandingEventPastUsecase landingEventPastUsecase;
  final LandingEventOngoingUsecase landingEventOngoingUsecase;

  LandingEventProvider({
    required this.landingEventUpcomingUsecase,
    required this.landingEventPastUsecase,
    required this.landingEventOngoingUsecase,
  });

  String? _errorMessage;

  //? Upcoming Event
  ResponseStatus _landingEventUpcomingStatus = ResponseStatus.initial;
  List<EventEntity>? _landingEventUpcoming;

  ResponseStatus _landingEventOngoingStatus = ResponseStatus.initial;
  List<EventEntity>? _landingEventOngoing;

  ResponseStatus _landingEventPastStatus = ResponseStatus.initial;
  List<EventEntity>? _landingEventPast;

  //* getter
  ResponseStatus get landingEventUpcomingStatus => _landingEventUpcomingStatus;
  List<EventEntity>? get landingEventUpcoming => _landingEventUpcoming;

  ResponseStatus get landingEventOngoingStatus => _landingEventOngoingStatus;
  List<EventEntity>? get landingEventOngoing => _landingEventOngoing;

  ResponseStatus get landingEventPastStatus => _landingEventPastStatus;
  List<EventEntity>? get landingEventPast => _landingEventPast;

  String get cleanErrorMessage => _errorMessage.cleanErrorMessage;

  void _setLandingEventUpcomingStatus(ResponseStatus status) {
    _landingEventUpcomingStatus = status;
    notifyListeners();
  }

  void _setLandingEventOngoingStatus(ResponseStatus status) {
    _landingEventOngoingStatus = status;
    notifyListeners();
  }

  void _setLandingEventPastStatus(ResponseStatus status) {
    _landingEventPastStatus = status;
    notifyListeners();
  }

  Future<void> getEventUpcoming({
    required String token,
    required int userId,
  }) async {
    _setLandingEventUpcomingStatus(ResponseStatus.loading);


    final result = await landingEventUpcomingUsecase.execute(token, userId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setLandingEventUpcomingStatus(ResponseStatus.error);
      },
      (events) {
        _landingEventUpcoming = events;
        _setLandingEventUpcomingStatus(ResponseStatus.success);
      },
    );
  }

  Future<void> getEventOngoing({
    required String token,
    required int userId,
  }) async {
    _setLandingEventOngoingStatus(ResponseStatus.loading);


    final result = await landingEventOngoingUsecase.execute(token, userId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setLandingEventOngoingStatus(ResponseStatus.error);
      },
      (events) {
        _landingEventOngoing = events;
        _setLandingEventOngoingStatus(ResponseStatus.success);
      },
    );
  }

  Future<void> getEventPast({
    required String token,
    required int userId,
  }) async {
    _setLandingEventPastStatus(ResponseStatus.loading);

    final result = await landingEventPastUsecase.execute(token, userId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setLandingEventPastStatus(ResponseStatus.error);
      },
      (events) {
        _landingEventPast = events;
        _setLandingEventPastStatus(ResponseStatus.success);
      },
    );
  }
}

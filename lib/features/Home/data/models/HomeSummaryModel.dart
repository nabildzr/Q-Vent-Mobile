import '../../domain/entities/HomeSummaryEntity.dart';

class HomeSummaryModel extends HomeSummaryEntity {
  const HomeSummaryModel({
    required super.pastCount,
    required super.upcomingEvent,
    required super.ongoingEvent,
    required super.currentMonthCount,
  });

  factory HomeSummaryModel.fromJson(Map<String, dynamic> data) {
    return HomeSummaryModel(
      pastCount: data['past_count'],
      upcomingEvent: data['upcoming_event'],
      ongoingEvent: data['ongoing_event'],
      currentMonthCount: data['current_month_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'past_count': pastCount,
      'upcoming_event': upcomingEvent,
      'ongoing_event': ongoingEvent,
      'current_month_count': currentMonthCount,
    };
  }
}

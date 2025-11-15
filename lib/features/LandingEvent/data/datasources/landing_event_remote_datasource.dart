import '../models/event_model.dart';

abstract class LandingEventRemoteDataSource {
  Future<List<EventModel>> getEventUpcoming(String token, int userId);
  Future<List<EventModel>> getEventOngoing(String token, int userId);
  Future<List<EventModel>> getEventPast(String token, int userId);
}

import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String? title;
  final String? location;
  final String? startDate;
  final String? endDate;
  final String? banner;
  final String? createdBy;

  const EventEntity({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.banner,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [id, title, location, startDate, endDate, banner, createdBy];
}

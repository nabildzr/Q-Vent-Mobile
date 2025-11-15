import 'package:equatable/equatable.dart';

class HomeEventHistoryEntity extends Equatable {
  final int id;
  final String title;
  final String category;
  final String endDate;
  final String banner;

  const  HomeEventHistoryEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.endDate,
    required this.banner,
  });

  @override
  List<Object?> get props => [id, title, category, endDate, banner];
}

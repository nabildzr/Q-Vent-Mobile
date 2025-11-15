import '../../domain/entities/HomeEventHistoryEntity.dart';

class HomeEventHistoryModel extends HomeEventHistoryEntity {
  const HomeEventHistoryModel({
    required super.id,
    required super.title,
    required super.category,
    required super.endDate,
    required super.banner,
  });

  factory HomeEventHistoryModel.fromJson(Map<String, dynamic> data) {
    return HomeEventHistoryModel(
      id: data['id'],
      title: data['title'],
      category: data['category'],
      endDate: data['end_date'],
      banner: data['banner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'end_date': endDate,
      'banner': banner,
    };
  }

  static List<HomeEventHistoryModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    return data
        .map((singleEvent) => HomeEventHistoryModel.fromJson(singleEvent))
        .toList();
  }
}

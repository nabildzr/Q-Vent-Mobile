
import '../../domain/entities/search_event_entity.dart';

class SearchEventModel extends SearchEventEntity {
  const SearchEventModel({
    required super.id,
    required super.title,
    required super.location,
    required super.startDate,
    required super.endDate,
    required super.banner,
    required super.createdBy,
  });

  factory SearchEventModel.fromJson(Map<String, dynamic> data) {
    
    return SearchEventModel(
      id: data['id'],
      title: data['title'],
      location: data['location'],
      startDate: data['start_date'],
      endDate: data['end_date'],
      banner: data['banner'],
      createdBy: data['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'start_date': startDate,
      'end_date': endDate,
      'banner': banner,
      'created_by': createdBy,
    };
  }

  static List<SearchEventModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    return data.map((singleEvent) => SearchEventModel.fromJson(singleEvent)).toList();
  }
}

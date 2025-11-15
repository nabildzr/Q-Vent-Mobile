import 'error_entity.dart';

class ErrorModel extends ErrorEntity {
  const ErrorModel({required super.error, required super.details});

  factory ErrorModel.fromJson(Map<String, dynamic> data) {
    final Map<String, List<String>> parsedDetails = {};

    if (data['details'] != null) {
      final detailsMap = data['details'] as Map<String, dynamic>;

      detailsMap.forEach((key, value) {
        if (value is List) {
          parsedDetails[key] = value.map((item) => item.toString()).toList();
        }
      });
    }

    return ErrorModel(
      error: data['error'] ?? 'Unknown error',
      details: parsedDetails,
    );
  }
}

import '../model/error_entity.dart';

class GeneralException implements Exception {
  final String message;

   GeneralException({required this.message});

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final ErrorEntity errorEntity;

   ValidationException({required this.errorEntity});

  
}

class ServerException implements Exception {
  final String message;

  const ServerException({required this.message});
}

class StatusCodeException implements Exception {
  final String message;

  const StatusCodeException({required this.message});
}

class EmptyException implements Exception {
  final String message;

  EmptyException({required this.message});

  @override
  String toString() => 'EmptyException: $message';
}

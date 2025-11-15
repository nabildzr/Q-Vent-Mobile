import 'package:equatable/equatable.dart';

import '../model/error_entity.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class GeneralFailure extends Failure {
  const GeneralFailure(super.message);
}

// allow to use for all error
class SimpleFailure extends Failure {
  const SimpleFailure(super.message);
}

class ValidationFailure extends Failure {
  final ErrorEntity errorEntity;

  const ValidationFailure(super.message, this.errorEntity);

  @override
  List<Object> get props => [message, errorEntity];
}

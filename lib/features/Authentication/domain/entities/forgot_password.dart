import 'package:equatable/equatable.dart';

class ForgotPasswordEntities extends Equatable {
  final String message;
  final String method;
  final String destination;

  const ForgotPasswordEntities({
   required this.message, required this.method, required this.destination
  });

  @override
  List<Object?> get props => [message, method, destination];
}

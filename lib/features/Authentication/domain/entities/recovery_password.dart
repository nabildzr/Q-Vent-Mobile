import 'package:equatable/equatable.dart';

class RecoveryPasswordEntity extends Equatable {
final String message;

const RecoveryPasswordEntity({required this.message});

  @override
  List<Object?> get props => [message];
}


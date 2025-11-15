import 'package:equatable/equatable.dart';

class AuthorizationEntity extends Equatable {
  final String token;
  final String expiresAt;

  const AuthorizationEntity({required this.token, required this.expiresAt});

  @override
  List<Object?> get props => [token, expiresAt];
}

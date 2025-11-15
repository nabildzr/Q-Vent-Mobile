import '../../domain/entities/forgot_password.dart';

class ForgotPasswordModel extends ForgotPasswordEntities {
  const ForgotPasswordModel({
    required super.message,
    required super.method,
    required super.destination,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> data) {
    return ForgotPasswordModel(
      message: data['message'],
      destination: data['destination'],
      method: data['method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'destination': destination, 'method': method};
  }
}

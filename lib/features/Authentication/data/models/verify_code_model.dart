import '../../domain/entities/verify_code.dart';

class VerifyCodeModel extends VerifyCodeEntities {
  const VerifyCodeModel({required super.message});

  factory VerifyCodeModel.fromJson(Map<String, dynamic> data) {
    return VerifyCodeModel(message: data['message']);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

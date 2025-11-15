import '../../domain/entities/recovery_password.dart';

class RecoveryPasswordModel extends RecoveryPasswordEntity {
  const RecoveryPasswordModel({required super.message});

  factory RecoveryPasswordModel.fromJson(Map<String, dynamic> data) {
    return RecoveryPasswordModel(message: data['message']);
}

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

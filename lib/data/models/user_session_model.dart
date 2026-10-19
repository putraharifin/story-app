import 'package:story_app/domain/entities/user_session.dart';

class UserSessionModel extends UserSession {
  const UserSessionModel({
    required super.userId,
    required super.name,
    required super.token,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }
}

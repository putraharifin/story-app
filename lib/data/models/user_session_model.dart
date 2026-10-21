import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/domain/entities/user_session.dart';

part 'user_session_model.freezed.dart';
part 'user_session_model.g.dart';

@freezed
abstract class UserSessionModel with _$UserSessionModel {
  const UserSessionModel._();

  const factory UserSessionModel({
    required String userId,
    required String name,
    required String token,
  }) = _UserSessionModel;

  factory UserSessionModel.fromJson(Map<String, dynamic> json) =>
      _$UserSessionModelFromJson(json);

  UserSession toEntity() {
    return UserSession(userId: userId, name: name, token: token);
  }
}

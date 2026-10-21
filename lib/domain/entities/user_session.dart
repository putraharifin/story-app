import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_session.freezed.dart';

@freezed
abstract class UserSession with _$UserSession {
  const factory UserSession({
    required String userId,
    required String name,
    required String token,
  }) = _UserSession;
}

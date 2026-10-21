// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSessionModel _$UserSessionModelFromJson(Map<String, dynamic> json) =>
    _UserSessionModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$UserSessionModelToJson(_UserSessionModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'token': instance.token,
    };

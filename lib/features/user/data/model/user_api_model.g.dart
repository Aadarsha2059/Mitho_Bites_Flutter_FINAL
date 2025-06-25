// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
  userId: json['_id'] as String? ?? '',
  fullname: json['fullname'] as String? ?? '',
  username: json['username'] as String? ?? '',
  password: json['password'] as String? ?? '',
  confirmpassword: json['confirmpassword'] as String? ?? '',
  phone: (json['phone'] as num?)?.toInt() ?? 0,
  address: json['address'] as String? ?? '',
  email: json['email'] as String? ?? '',
);

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'fullname': instance.fullname,
      'username': instance.username,
      'password': instance.password,
      'confirmpassword': instance.confirmpassword,
      'phone': instance.phone,
      'address': instance.address,
      'email': instance.email,
    };

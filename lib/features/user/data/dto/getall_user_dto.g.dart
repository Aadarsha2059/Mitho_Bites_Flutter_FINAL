// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getall_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllUserDTO _$GetAllUserDTOFromJson(Map<String, dynamic> json) =>
    GetAllUserDTO(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => UserApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllUserDTOToJson(GetAllUserDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };

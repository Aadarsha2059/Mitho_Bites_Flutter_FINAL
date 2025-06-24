// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantApiModel _$RestaurantApiModelFromJson(Map<String, dynamic> json) =>
    RestaurantApiModel(
      restaurantId: json['_id'] as String?,
      name: json['name'] as String,
      contact: json['contact'] as String,
      location: json['location'] as String,
      filepath: json['filepath'] as String?,
    );

Map<String, dynamic> _$RestaurantApiModelToJson(RestaurantApiModel instance) =>
    <String, dynamic>{
      '_id': instance.restaurantId,
      'name': instance.name,
      'contact': instance.contact,
      'location': instance.location,
      'filepath': instance.filepath,
    };

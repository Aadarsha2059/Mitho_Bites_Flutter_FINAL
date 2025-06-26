// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      productId: json['_id'] as String?,
      name: json['name'] as String,
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      filepath: json['filepath'] as String?,
      categoryId: json['categoryId'] as String?,
      restaurantId: json['restaurantId'] as String?,
      isAvailable: json['isAvailable'] as bool,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'type': instance.type,
      'price': instance.price,
      'description': instance.description,
      'filepath': instance.filepath,
      'categoryId': instance.categoryId,
      'restaurantId': instance.restaurantId,
      'isAvailable': instance.isAvailable,
    };

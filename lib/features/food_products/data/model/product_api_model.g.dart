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
      image: json['image'] as String?,
      categoryId: json['categoryId'] as String?,
      restaurantId: json['restaurantId'] as String?,
      isAvailable: json['isAvailable'] as bool,
      categoryName: json['categoryName'] as String?,
      categoryImage: json['categoryImage'] as String?,
      restaurantName: json['restaurantName'] as String?,
      restaurantImage: json['restaurantImage'] as String?,
      restaurantLocation: json['restaurantLocation'] as String?,
      restaurantContact: json['restaurantContact'] as String?,
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.productId,
      'name': instance.name,
      'type': instance.type,
      'price': instance.price,
      'description': instance.description,
      'image': instance.image,
      'categoryId': instance.categoryId,
      'restaurantId': instance.restaurantId,
      'isAvailable': instance.isAvailable,
      'categoryName': instance.categoryName,
      'categoryImage': instance.categoryImage,
      'restaurantName': instance.restaurantName,
      'restaurantImage': instance.restaurantImage,
      'restaurantLocation': instance.restaurantLocation,
      'restaurantContact': instance.restaurantContact,
    };

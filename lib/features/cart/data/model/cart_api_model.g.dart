// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemApiModel _$CartItemApiModelFromJson(Map<String, dynamic> json) =>
    CartItemApiModel(
      cartItemId: json['_id'] as String?,
      productId:
          ProductApiModel.fromJson(json['productId'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CartItemApiModelToJson(CartItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.cartItemId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

CartApiModel _$CartApiModelFromJson(Map<String, dynamic> json) => CartApiModel(
      cartId: json['_id'] as String?,
      userId: json['userId'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CartApiModelToJson(CartApiModel instance) =>
    <String, dynamic>{
      '_id': instance.cartId,
      'userId': instance.userId,
      'items': instance.items,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

CartResponseModel _$CartResponseModelFromJson(Map<String, dynamic> json) =>
    CartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : CartApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartResponseModelToJson(CartResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

AddToCartRequestModel _$AddToCartRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddToCartRequestModel(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$AddToCartRequestModelToJson(
        AddToCartRequestModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
    };

UpdateCartItemRequestModel _$UpdateCartItemRequestModelFromJson(
        Map<String, dynamic> json) =>
    UpdateCartItemRequestModel(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateCartItemRequestModelToJson(
        UpdateCartItemRequestModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

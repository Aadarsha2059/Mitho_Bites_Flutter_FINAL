// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackApiModel _$FeedbackApiModelFromJson(Map<String, dynamic> json) =>
    FeedbackApiModel(
      feedbackId: json['_id'] as String?,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FeedbackApiModelToJson(FeedbackApiModel instance) =>
    <String, dynamic>{
      '_id': instance.feedbackId,
      'userId': instance.userId,
      'productId': instance.productId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

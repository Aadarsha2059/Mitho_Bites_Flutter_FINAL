import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:json_annotation/json_annotation.dart';


part 'feedback_api_model.g.dart';

@JsonSerializable()
class FeedbackApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? feedbackId;
  final String userId;
  final String productId;
  final int rating;
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FeedbackApiModel({
    this.feedbackId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory FeedbackApiModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackApiModelFromJson(json);

  Map<String, dynamic> toJson({bool forSubmission = false}) {
    final json = <String, dynamic>{
      'userId': userId,
      'productId': productId,
      'rating': rating,
      'comment': comment,
    };
    if (!forSubmission) {
      json['_id'] = feedbackId;
      if (createdAt != null) json['createdAt'] = createdAt?.toIso8601String();
      if (updatedAt != null) json['updatedAt'] = updatedAt?.toIso8601String();
    }
    return json;
  }

  // to entity
  FeedbackEntity toEntity() {
    return FeedbackEntity(
      feedbackId: feedbackId,
      userId: userId,
      productId: productId,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // from entity
  factory FeedbackApiModel.fromEntity(FeedbackEntity entity) {
    return FeedbackApiModel(
      feedbackId: entity.feedbackId,
      userId: entity.userId,
      productId: entity.productId,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        feedbackId,
        userId,
        productId,
        rating,
        comment,
        createdAt,
        updatedAt,
      ];
}
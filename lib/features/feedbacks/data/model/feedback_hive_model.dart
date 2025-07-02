import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';



part 'feedback_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.feedbackTableId) 
class FeedbackHiveModel extends Equatable {
  @HiveField(0)
  final String? feedbackId;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String productId;
  @HiveField(3)
  final int rating;
  @HiveField(4)
  final String comment;
  @HiveField(5)
  final DateTime? createdAt;
  @HiveField(6)
  final DateTime? updatedAt;

  FeedbackHiveModel({
    String? feedbackId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  }) : feedbackId = feedbackId ?? const Uuid().v4();

  // Initial constructor
  const FeedbackHiveModel.initial()
      : feedbackId = '',
        userId = '',
        productId = '',
        rating = 1,
        comment = '',
        createdAt = null,
        updatedAt = null;

  // From entity
  factory FeedbackHiveModel.fromEntity(FeedbackEntity entity) {
    return FeedbackHiveModel(
      feedbackId: entity.feedbackId,
      userId: entity.userId,
      productId: entity.productId,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // To entity
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
import 'package:equatable/equatable.dart';

class FeedbackEntity extends Equatable {
  final String? feedbackId; // MongoDB _id
  final String userId;
  final String productId;
  final int rating; // 1-5
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FeedbackEntity({
    this.feedbackId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  });

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
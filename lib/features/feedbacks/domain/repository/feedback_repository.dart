import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IFeedbackRepository {
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksForProduct(String productId);
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksByUser(String userId);
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback);
  Future<Either<Failure, void>> clearFeedbacks();
} 
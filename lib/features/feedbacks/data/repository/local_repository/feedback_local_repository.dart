import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/data/data_source/local_datasource/feedback_local_datasource.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/repository/feedback_repository.dart';

class FeedbackLocalRepository implements IFeedbackRepository {
  final FeedbackLocalDatasource _feedbackLocalDatasource;

  FeedbackLocalRepository({
    required FeedbackLocalDatasource feedbackLocalDatasource,
  }) : _feedbackLocalDatasource = feedbackLocalDatasource;

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksForProduct(String productId) async {
    try {
      final feedbacks = await _feedbackLocalDatasource.getFeedbacksForProduct(productId);
      return Right(feedbacks);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksByUser(String userId) async {
    try {
      final feedbacks = await _feedbackLocalDatasource.getFeedbacksByUser(userId);
      return Right(feedbacks);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback) async {
    try {
      await _feedbackLocalDatasource.submitFeedback(feedback);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearFeedbacks() async {
    try {
      await _feedbackLocalDatasource.clearFeedbacks();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

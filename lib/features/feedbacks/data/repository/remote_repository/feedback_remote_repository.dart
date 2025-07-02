import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/data/data_source/remote_datasource/feedback_remote_datasource.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/repository/feedback_repository.dart';

class FeedbackRemoteRepository implements IFeedbackRepository {
  final FeedbackRemoteDatasource _feedbackRemoteDatasource;

  FeedbackRemoteRepository({
    required FeedbackRemoteDatasource feedbackRemoteDatasource,
  }) : _feedbackRemoteDatasource = feedbackRemoteDatasource;

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksForProduct(String productId) async {
    try {
      final feedbacks = await _feedbackRemoteDatasource.getFeedbacksForProduct(productId);
      return Right(feedbacks);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksByUser(String userId) async {
    try {
      final feedbacks = await _feedbackRemoteDatasource.getFeedbacksByUser(userId);
      return Right(feedbacks);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback) async {
    try {
      await _feedbackRemoteDatasource.submitFeedback(feedback);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearFeedbacks() async {
    try {
      await _feedbackRemoteDatasource.clearFeedbacks();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
} 
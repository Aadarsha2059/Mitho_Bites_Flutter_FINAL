import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/data/repository//local_repository/feedback_local_repository.dart';
import 'package:fooddelivery_b/features/feedbacks/data/repository/remote_repository/feedback_remote_repository.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/repository/feedback_repository.dart';

class FeedbackRepositoryImpl implements IFeedbackRepository {
  final FeedbackLocalRepository _localRepository;
  final FeedbackRemoteRepository _remoteRepository;

  FeedbackRepositoryImpl({
    required FeedbackLocalRepository localRepository,
    required FeedbackRemoteRepository remoteRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksForProduct(String productId) async {
    final localResult = await _localRepository.getFeedbacksForProduct(productId);
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getFeedbacksForProduct(productId);
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (feedbacks) async {
            await _localRepository.clearFeedbacks();
            for (final feedback in feedbacks) {
              await _localRepository.submitFeedback(feedback);
            }
            return Right(feedbacks);
          },
        );
      },
      (localFeedbacks) {
        _refreshFeedbacksForProductInBackground(productId);
        return Right(localFeedbacks);
      },
    );
  }

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacksByUser(String userId) async {
    final localResult = await _localRepository.getFeedbacksByUser(userId);
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getFeedbacksByUser(userId);
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (feedbacks) async {
            await _localRepository.clearFeedbacks();
            for (final feedback in feedbacks) {
              await _localRepository.submitFeedback(feedback);
            }
            return Right(feedbacks);
          },
        );
      },
      (localFeedbacks) {
        _refreshFeedbacksByUserInBackground(userId);
        return Right(localFeedbacks);
      },
    );
  }

  @override
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback) async {
    final remoteResult = await _remoteRepository.submitFeedback(feedback);
    return remoteResult.fold(
      (failure) => Left(failure),
      (_) async {
        await _localRepository.submitFeedback(feedback);
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> clearFeedbacks() async {
    return await _localRepository.clearFeedbacks();
  }

  void _refreshFeedbacksForProductInBackground(String productId) async {
    try {
      final remoteResult = await _remoteRepository.getFeedbacksForProduct(productId);
      remoteResult.fold(
        (failure) {},
        (feedbacks) async {
          await _localRepository.clearFeedbacks();
          for (final feedback in feedbacks) {
            await _localRepository.submitFeedback(feedback);
          }
        },
      );
    } catch (e) {
      // Silent fail
    }
  }

  void _refreshFeedbacksByUserInBackground(String userId) async {
    try {
      final remoteResult = await _remoteRepository.getFeedbacksByUser(userId);
      remoteResult.fold(
        (failure) {},
        (feedbacks) async {
          await _localRepository.clearFeedbacks();
          for (final feedback in feedbacks) {
            await _localRepository.submitFeedback(feedback);
          }
        },
      );
    } catch (e) {
      // Silent fail
    }
  }
} 
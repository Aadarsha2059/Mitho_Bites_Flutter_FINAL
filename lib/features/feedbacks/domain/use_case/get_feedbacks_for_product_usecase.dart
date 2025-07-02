import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/repository/feedback_repository.dart';

class GetFeedbacksForProductUsecase implements UseCaseWithParams<List<FeedbackEntity>, String> {
  final IFeedbackRepository _feedbackRepository;

  GetFeedbacksForProductUsecase({required IFeedbackRepository feedbackRepository})
      : _feedbackRepository = feedbackRepository;

  @override
  Future<Either<Failure, List<FeedbackEntity>>> call(String productId) {
    return _feedbackRepository.getFeedbacksForProduct(productId);
  }
} 
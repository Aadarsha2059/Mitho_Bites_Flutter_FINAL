import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/repository/feedback_repository.dart';

class SubmitFeedbackUsecase implements UseCaseWithParams<void, FeedbackEntity> {
  final IFeedbackRepository _feedbackRepository;

  SubmitFeedbackUsecase({required IFeedbackRepository feedbackRepository})
      : _feedbackRepository = feedbackRepository;

  @override
  Future<Either<Failure, void>> call(FeedbackEntity feedback) {
    return _feedbackRepository.submitFeedback(feedback);
  }
} 
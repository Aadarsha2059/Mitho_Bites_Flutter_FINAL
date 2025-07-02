import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/repository/feedback_repository.dart';

class ClearFeedbacksUsecase implements UsecaseWithoutParams<void> {
  final IFeedbackRepository _feedbackRepository;

  ClearFeedbacksUsecase({required IFeedbackRepository feedbackRepository})
      : _feedbackRepository = feedbackRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _feedbackRepository.clearFeedbacks();
  }
} 
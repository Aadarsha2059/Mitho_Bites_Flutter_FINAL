import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';

class FeedbackState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<FeedbackEntity> feedbacks;
  final bool isSubmitting;
  final String? submitError;
  final bool submitSuccess;

  const FeedbackState({
    this.isLoading = false,
    this.error,
    this.feedbacks = const [],
    this.isSubmitting = false,
    this.submitError,
    this.submitSuccess = false,
  });

  FeedbackState copyWith({
    bool? isLoading,
    String? error,
    List<FeedbackEntity>? feedbacks,
    bool? isSubmitting,
    String? submitError,
    bool? submitSuccess,
  }) {
    return FeedbackState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      feedbacks: feedbacks ?? this.feedbacks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError,
      submitSuccess: submitSuccess ?? this.submitSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, feedbacks, isSubmitting, submitError, submitSuccess];
} 
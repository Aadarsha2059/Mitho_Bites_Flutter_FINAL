import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/use_case/get_feedbacks_for_product_usecase.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/use_case/submit_feedback_usecase.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/state/feedback_state.dart';

class FeedbackViewModel extends ChangeNotifier {
  final GetFeedbacksForProductUsecase _getFeedbacksForProductUsecase;
  final SubmitFeedbackUsecase _submitFeedbackUsecase;

  FeedbackState _state = const FeedbackState();
  FeedbackState get state => _state;

  FeedbackViewModel({
    required GetFeedbacksForProductUsecase getFeedbacksForProductUsecase,
    required SubmitFeedbackUsecase submitFeedbackUsecase,
  })  : _getFeedbacksForProductUsecase = getFeedbacksForProductUsecase,
        _submitFeedbackUsecase = submitFeedbackUsecase;

  Future<void> loadFeedbacksForProduct(String productId) async {
    _state = _state.copyWith(isLoading: true, error: null, submitSuccess: false);
    notifyListeners();
    final result = await _getFeedbacksForProductUsecase(productId);
    result.fold(
      (failure) {
        _state = _state.copyWith(isLoading: false, error: failure.message, feedbacks: []);
        notifyListeners();
      },
      (feedbacks) {
        _state = _state.copyWith(isLoading: false, error: null, feedbacks: feedbacks);
        notifyListeners();
      },
    );
  }

  Future<void> submitFeedback(FeedbackEntity feedback) async {
    _state = _state.copyWith(isSubmitting: true, submitError: null, submitSuccess: false);
    notifyListeners();
    final result = await _submitFeedbackUsecase(feedback);
    result.fold(
      (failure) {
        _state = _state.copyWith(isSubmitting: false, submitError: failure.message, submitSuccess: false);
        notifyListeners();
      },
      (_) {
        _state = _state.copyWith(isSubmitting: false, submitError: null, submitSuccess: true);
        notifyListeners();
      },
    );
  }

  void resetSubmitStatus() {
    _state = _state.copyWith(submitSuccess: false, submitError: null);
    notifyListeners();
  }
} 
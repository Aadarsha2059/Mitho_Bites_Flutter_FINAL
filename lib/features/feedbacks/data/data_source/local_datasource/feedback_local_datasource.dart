import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/feedbacks/data/data_source/feedback_datasource.dart';
import 'package:fooddelivery_b/features/feedbacks/data/model/feedback_hive_model.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FeedbackLocalDatasource implements IFeedbackDataSource {
  final HiveService _hiveService;

  FeedbackLocalDatasource({required HiveService hiveService}) : _hiveService = hiveService;

  @override
  Future<List<FeedbackEntity>> getFeedbacksForProduct(String productId) async {
    try {
      var box = await Hive.openBox<FeedbackHiveModel>(HiveTableConstant.feedbackBox);
      return box.values
          .where((model) => model.productId == productId)
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw Exception("Failed to get feedbacks for product: $e");
    }
  }

  @override
  Future<List<FeedbackEntity>> getFeedbacksByUser(String userId) async {
    try {
      var box = await Hive.openBox<FeedbackHiveModel>(HiveTableConstant.feedbackBox);
      return box.values
          .where((model) => model.userId == userId)
          .map((model) => model.toEntity())
          .toList();
    } catch (e) {
      throw Exception("Failed to get feedbacks by user: $e");
    }
  }

  @override
  Future<void> submitFeedback(FeedbackEntity feedback) async {
    try {
      var box = await Hive.openBox<FeedbackHiveModel>(HiveTableConstant.feedbackBox);
      final hiveModel = FeedbackHiveModel.fromEntity(feedback);
      await box.put(hiveModel.feedbackId, hiveModel);
    } catch (e) {
      throw Exception("Failed to submit feedback: $e");
    }
  }

  @override
  Future<void> clearFeedbacks() async {
    try {
      var box = await Hive.openBox<FeedbackHiveModel>(HiveTableConstant.feedbackBox);
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear feedbacks: $e");
    }
  }
} 
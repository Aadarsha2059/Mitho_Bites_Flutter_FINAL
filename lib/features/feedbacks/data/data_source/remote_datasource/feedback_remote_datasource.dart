import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/feedbacks/data/data_source/feedback_datasource.dart';
import 'package:fooddelivery_b/features/feedbacks/data/model/feedback_api_model.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';

class FeedbackRemoteDatasource implements IFeedbackDataSource {
  final ApiService _apiService;

  FeedbackRemoteDatasource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<FeedbackEntity>> getFeedbacksForProduct(String productId) async {
    try {
      final response = await _apiService.dio.get(
        'feedbacks/product/$productId',
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true && responseData['feedbacks'] != null) {
          final List<dynamic> feedbacksData = responseData['feedbacks'];
          return feedbacksData
              .map((json) => FeedbackApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          return responseData
              .map((json) => FeedbackApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get feedbacks: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get feedbacks: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get feedbacks: $e');
    }
  }

  @override
  Future<List<FeedbackEntity>> getFeedbacksByUser(String userId) async {
    try {
      // The backend gets user from auth, so userId is not used in the request
      final response = await _apiService.dio.get('feedbacks/user');
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true && responseData['feedbacks'] != null) {
          final List<dynamic> feedbacksData = responseData['feedbacks'];
          return feedbacksData
              .map((json) => FeedbackApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          return responseData
              .map((json) => FeedbackApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get feedbacks: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get feedbacks: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get feedbacks: $e');
    }
  }

  @override
  Future<void> submitFeedback(FeedbackEntity feedback) async {
    try {
      final model = FeedbackApiModel.fromEntity(feedback);
      final response = await _apiService.dio.post(
        'feedbacks',
        data: model.toJson(forSubmission: true),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to submit feedback');
        }
      } else {
        throw Exception('Failed to submit feedback: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to submit feedback: ${e.message}');
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  @override
  Future<void> clearFeedbacks() async {
    // Not supported on remote
    throw UnimplementedError('Clearing feedbacks is not supported on remote');
  }
}

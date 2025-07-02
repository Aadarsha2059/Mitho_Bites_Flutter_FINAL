
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';

abstract interface class IFeedbackDataSource {
 
  Future<List<FeedbackEntity>> getFeedbacksForProduct(String productId);

  
  Future<List<FeedbackEntity>> getFeedbacksByUser(String userId);


  Future<void> submitFeedback(FeedbackEntity feedback);

 
  Future<void> clearFeedbacks();
}

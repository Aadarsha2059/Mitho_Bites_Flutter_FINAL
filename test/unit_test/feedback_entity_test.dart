import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';

void main() {
  group('FeedbackEntity', () {
    test('Can create with required fields', () {
      final feedback = FeedbackEntity(
        userId: 'u1',
        productId: 'p1',
        rating: 5,
        comment: 'Great!',
      );
      expect(feedback.userId, 'u1');
      expect(feedback.productId, 'p1');
      expect(feedback.rating, 5);
      expect(feedback.comment, 'Great!');
      expect(feedback.feedbackId, isNull);
      expect(feedback.createdAt, isNull);
      expect(feedback.updatedAt, isNull);
    });

    test('Can create with all fields', () {
      final now = DateTime.now();
      final feedback = FeedbackEntity(
        feedbackId: 'f1',
        userId: 'u2',
        productId: 'p2',
        rating: 4,
        comment: 'Good',
        createdAt: now,
        updatedAt: now,
      );
      expect(feedback.feedbackId, 'f1');
      expect(feedback.userId, 'u2');
      expect(feedback.productId, 'p2');
      expect(feedback.rating, 4);
      expect(feedback.comment, 'Good');
      expect(feedback.createdAt, now);
      expect(feedback.updatedAt, now);
    });
  });
} 
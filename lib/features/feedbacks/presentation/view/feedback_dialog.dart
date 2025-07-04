import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/feedbacks/domain/entity/feedback_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view_model/feedback_view_model.dart';

class FeedbackDialog extends StatefulWidget {
  final String userId;
  final String productId;
  final String productName;
  final String? productImage;
  final String? restaurantName;

  const FeedbackDialog({
    super.key,
    required this.userId,
    required this.productId,
    required this.productName,
    this.productImage,
    this.restaurantName,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int _rating = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackViewModel = Provider.of<FeedbackViewModel>(context);
    final isSubmitting = feedbackViewModel.state.isSubmitting;
    final submitError = feedbackViewModel.state.submitError;
    final submitSuccess = feedbackViewModel.state.submitSuccess;

    Future<void> showThankYouDialog() async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    const Icon(Icons.emoji_emotions, color: Colors.amber, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Thank you for your valuable ratings and feedbacks!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We will improve our qualities in the days to come.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AlertDialog(
      title: Text('Rate ${widget.productName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.productImage != null && widget.productImage!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.productImage!,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (widget.restaurantName != null && widget.restaurantName!.isNotEmpty) ...[
            Text('From: ${widget.restaurantName!}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
          ],
          _StarRatingBar(
            rating: _rating,
            onRatingChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
          ),
          if (submitError != null) ...[
            const SizedBox(height: 8),
            Text(submitError, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () async {
                  final feedback = FeedbackEntity(
                    userId: widget.userId,
                    productId: widget.productId,
                    rating: _rating,
                    comment: _commentController.text.trim(),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  await feedbackViewModel.submitFeedback(feedback);
                  if (feedbackViewModel.state.submitSuccess && context.mounted) {
                    Navigator.of(context).pop(true);
                    await showThankYouDialog();
                  }
                },
          child: isSubmitting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Submit'),
        ),
      ],
    );
  }
}

class _StarRatingBar extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  const _StarRatingBar({required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isFilled = index < rating;
        return IconButton(
          icon: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () => onRatingChanged(index + 1),
        );
      }),
    );
  }
} 
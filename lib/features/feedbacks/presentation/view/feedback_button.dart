import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view/feedback_dialog.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view_model/feedback_view_model.dart';

class FeedbackButton extends StatelessWidget {
  final String userId;
  final String productId;
  final String productName;
  final String? productImage;
  final String? restaurantName;

  const FeedbackButton({
    Key? key,
    required this.userId,
    required this.productId,
    required this.productName,
    this.productImage,
    this.restaurantName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.star, color: Colors.white),
      label: const Text('Rate'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (ctx) => ChangeNotifierProvider.value(
            value: Provider.of<FeedbackViewModel>(context, listen: false),
            child: FeedbackDialog(
              userId: userId,
              productId: productId,
              productName: productName,
              productImage: productImage,
              restaurantName: restaurantName,
            ),
          ),
        );
        if (result == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')),
          );
        }
      },
    );
  }
} 
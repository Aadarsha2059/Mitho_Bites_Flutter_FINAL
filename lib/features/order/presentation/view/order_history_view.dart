import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view/feedback_button.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view_model/feedback_view_model.dart';
import 'package:get_it/get_it.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Consumer<OrderViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }
          if (viewModel.filteredOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No orders found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }
          return Column(
            children: [
              _OrderStatusTabs(viewModel: viewModel),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = viewModel.filteredOrders[index];
                    return _OrderCard(order: order);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderStatusTabs extends StatelessWidget {
  final OrderViewModel viewModel;
  const _OrderStatusTabs({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: OrderStatusFilter.values.map((filter) {
        final label = filter.toString().split('.').last;
        return ChoiceChip(
          label: Text(label[0].toUpperCase() + label.substring(1)),
          selected: viewModel.filter == filter,
          onSelected: (_) => viewModel.setFilter(filter),
        );
      }).toList(),
    );
  }
}

Widget _statusChip(String status) {
  Color color;
  switch (status) {
    case 'pending':
      color = Colors.orange;
      break;
    case 'received':
      color = Colors.green;
      break;
    case 'cancelled':
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
  }
  return Chip(
    label: Text(
      status[0].toUpperCase() + status.substring(1),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: color,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  );
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final itemSummary = order.items.isNotEmpty
        ? (order.items[0] is Map<String, dynamic> && order.items[0].containsKey('productName')
            ? order.items[0]['productName']
            : 'Item')
        : 'No items';
    final moreItems = order.items.length > 1 ? ' +${order.items.length - 1} more' : '';
    final viewModel = Provider.of<OrderViewModel>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange.shade50,
          child: const Icon(Icons.receipt_long, color: Colors.deepOrange),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order #${order.id?.substring(order.id!.length - 5) ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            _statusChip(order.orderStatus),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '$itemSummary$moreItems',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Text(
              'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13, color: Colors.deepOrange),
            ),
            const SizedBox(height: 2),
            Text(
              'Placed: ${order.orderDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (order.orderStatus == 'pending') ...[
              const SizedBox(height: 8),
              Consumer<OrderViewModel>(
                builder: (context, viewModel, _) {
                  final isUpdating = viewModel.isUpdating;
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: isUpdating
                              ? null
                              : () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Cancel Order?'),
                                      content: const Text('Are you sure you want to cancel this order?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(false),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(true),
                                          child: const Text('Yes, Cancel'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    final success = await viewModel.cancelOrder(order.id ?? '');
                                    if (context.mounted && success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order cancelled and moved to Cancelled tab.')),
                                      );
                                    } else if (context.mounted && !success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(viewModel.updateError ?? 'Failed to cancel order.')),
                                      );
                                    }
                                  }
                                },
                          label: isUpdating
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Cancel My Order'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: isUpdating
                              ? null
                              : () async {
                                  final success = await viewModel.markOrderReceived(order.id ?? '');
                                  if (context.mounted && success) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('🎉 Congratulations Fooodiee!'),
                                        content: const Text(
                                          'We are so happy to deliver foods for you on time. Keep on ordering. 20+ token will provide you exciting gift hampers.'
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (context.mounted && !success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(viewModel.updateError ?? 'Failed to update order status.')),
                                    );
                                  }
                                },
                          label: isUpdating
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Received My Order'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            if (order.orderStatus == 'received') ...[
              const SizedBox(height: 8),
              const Text('Rate your food items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.items.whereType<Map<String, dynamic>>().map<Widget>((item) {
                final productId = item['productId'] is Map
                    ? item['productId']['_id']?.toString() ?? ''
                    : item['productId']?.toString() ?? '';
                final productName = item['productName']?.toString() ?? 'Food Item';
                final productImage = item['productImage']?.toString();
                final restaurantName = item['restaurantName']?.toString();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ChangeNotifierProvider(
                    create: (_) => GetIt.I<FeedbackViewModel>(),
                    builder: (context, child) => FeedbackButton(
                      userId: order.userId,
                      productId: productId,
                      productName: productName,
                      productImage: productImage,
                      restaurantName: restaurantName,
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
        onTap: () {
          // TODO: Show order details dialog/page
        },
      ),
    );
  }
} 
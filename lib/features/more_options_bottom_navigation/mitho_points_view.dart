import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';

class MithoPoints extends StatefulWidget {
  final int itemsReceived;
  const MithoPoints({Key? key, required this.itemsReceived}) : super(key: key);

  @override
  State<MithoPoints> createState() => _MithoPointsState();
}

class _MithoPointsState extends State<MithoPoints> with SingleTickerProviderStateMixin {
  bool showPreview = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    if (widget.itemsReceived >= 20) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MithoPoints oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemsReceived >= 20 && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int items = showPreview ? 20 : widget.itemsReceived;
    final bool unlocked = items >= 20;
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      shadowColor: Colors.orange.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stars, color: Colors.amber[700], size: 32),
                const SizedBox(width: 8),
                Text(
                  'Mitho Points',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: unlocked
                  ? ScaleTransition(scale: _scaleAnimation, child: _buildUnlockedCoin())
                  : _buildLockedCoin(20 - items),
            ),
            const SizedBox(height: 18),
            if (!unlocked)
              Text(
                'You are ${20 - items} order${20 - items == 1 ? '' : 's'} away from a Lucky Token Coin!',
                style: const TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            if (unlocked)
              Column(
                children: [
                  Text(
                    'Congratulations! You have received a Lucky Token Coin for your loyalty! 🎉',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                      shadows: [Shadow(color: Colors.green.shade100, blurRadius: 8)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Enjoy your gift hamper!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.emoji_objects, color: Colors.amber),
              label: const Text('What if I received 20 items?'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange[800],
                side: BorderSide(color: Colors.orange[300]!, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  showPreview = !showPreview;
                  if (showPreview) {
                    _controller.forward(from: 0);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedCoin(int ordersLeft) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.lock, size: 70, color: Colors.grey[300]),
            Icon(Icons.monetization_on, size: 54, color: Colors.amber[200]),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Lucky Token Coin (Locked)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedCoin() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Colorful burst background
            SizedBox(
              width: 90,
              height: 90,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.orange,
                      Colors.yellow,
                      Colors.pink,
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Coin popping out of a box/cartoon
            Icon(Icons.card_giftcard, size: 70, color: Colors.brown[300]),
            Positioned(
              top: 14,
              child: Icon(
                Icons.monetization_on,
                size: 54,
                color: Colors.amber[700],
                shadows: [Shadow(color: Colors.amber.shade200, blurRadius: 12)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Lucky Token Coin (Unlocked!)',
          style: TextStyle(
            fontSize: 18,
            color: Colors.orange[800],
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.orange.shade100, blurRadius: 8)],
          ),
        ),
      ],
    );
  }
}

class MithoPointsPagee extends StatelessWidget {
  const MithoPointsPagee({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderViewModel>(
      create: (_) => OrderViewModel(
        getOrdersUsecase: serviceLocator(),
        updateOrderStatusUsecase: serviceLocator(),
        cancelOrderUsecase: serviceLocator(),
        markOrderReceivedUsecase: serviceLocator(),
      )..fetchOrders(),
      child: Consumer<OrderViewModel>(
        builder: (context, orderViewModel, _) {
          if (orderViewModel.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Mitho Points'),
                backgroundColor: Colors.deepOrange,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (orderViewModel.error != null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Mitho Points'),
                backgroundColor: Colors.deepOrange,
              ),
              body: Center(child: Text('Error: ${orderViewModel.error}')),
            );
          }
          // Count all items in received orders
          final receivedOrders = orderViewModel.orders.where(
            (o) => o.orderStatus == 'received',
          );
          int itemsReceived = 0;
          for (final order in receivedOrders) {
            itemsReceived += order.items.length;
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mitho Points'),
              backgroundColor: Colors.deepOrange,
            ),
            body: Center(child: MithoPoints(itemsReceived: itemsReceived)),
          );
        },
      ),
    );
  }
}
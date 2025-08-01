import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/khana_khajana_view.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/mitho_points_view.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/settings_page/setting_page_view.dart';
import 'package:fooddelivery_b/features/order/presentation/view/more_orders_screen.dart';
import 'package:fooddelivery_b/miscellaneous/view/about_assignment.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view/feedback_button.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view_model/feedback_view_model.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/update_profile/profile_view.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/purchase_trend_page.dart';


class MoreView extends StatelessWidget {
  const MoreView({super.key});

  Widget _buildMoreItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor ?? Colors.deepOrange.shade100,
          child: Icon(icon, color: Colors.deepOrange),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Options'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildMoreItem(
            icon: Icons.history,
            title: 'Order History',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoreOrdersScreen()),
                ),
          ),
          _buildMoreItem(
            icon: Icons.person,
            title: 'Update My Profile',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UpdateProfilePageeWrapper()),
                ),
            iconColor: Colors.green.shade100,
          ),
          _buildMoreItem(
            icon: Icons.food_bank,
            title: 'Khana Khajana',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KhanaKhajanaView()),
                ),
            iconColor: Colors.red.shade100,
          ),
          _buildMoreItem(
            icon: Icons.show_chart,
            title: 'My Purchase Trend',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PurchaseTrendPage()),
              );
            },
            iconColor: Colors.indigo.shade100,
          ),
          _buildMoreItem(
            icon: Icons.stars,
            title: 'Mitho Points',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MithoPointsPagee()),
                ),
            iconColor: Colors.purple.shade100,
          ),
          _buildMoreItem(
            icon: Icons.support_agent,
            title: 'Help & Support',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutAssignmentPage(),
                  ),
                ),
            iconColor: Colors.blue.shade100,
          ),
          _buildMoreItem(
            icon: Icons.share,
            title: 'Give Feedbacks',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GiveFeedbacksPage()),
                ),
            iconColor: Colors.amber.shade100,
          ),
          _buildMoreItem(
            icon: Icons.settings,
            title: 'App Settings',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPageView()),
                ),
            iconColor: Colors.teal.shade100,
          ),
          const SizedBox(height: 20),
          _buildMoreItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginView()),
                (route) => false,
              );
            },
            iconColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

// --------------------- INDIVIDUAL PAGES ---------------------

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder:
            (context, index) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.fastfood),
                title: Text('Order #${index + 101}'),
                subtitle: const Text('Delivered on: 2024-08-2X'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
      ),
    );
  }
}

class KhanaKhajanaPage extends StatelessWidget {
  const KhanaKhajanaPage({super.key});

  final List<String> foodFacts = const [
    "1. Carrots were originally purple in color.",
    "2. Honey never spoils. Archaeologists found 3000-year-old honey in Egyptian tombs!",
    "3. Apples float because 25% of their volume is air.",
    "4. Bananas are berries, but strawberries are not!",
    "5. Dark chocolate is rich in antioxidants and improves heart health.",
    "6. Watermelons are 92% water – perfect for hydration.",
    "7. Broccoli contains more protein than steak (per calorie)!",
    "8. Yogurt boosts digestion and contains probiotics.",
    "9. Garlic can help reduce blood pressure naturally.",
    "10. Spinach was made popular by Popeye – and it's actually very rich in iron.",
    "11. Avocados contain healthy fats good for brain function.",
    "12. Chia seeds can absorb up to 10x their weight in water.",
    "13. Oats help reduce cholesterol and are great for your heart.",
    "14. Lemons have more sugar than strawberries – yet still taste sour.",
    "15. Mushrooms are the only plant-based source of natural vitamin D.",
    "16. Red bell peppers have more vitamin C than oranges.",
    "17. Eating spicy food may boost your metabolism.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khana Khajana'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: foodFacts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(
                Icons.food_bank_outlined,
                color: Colors.deepOrange,
              ),
              title: Text(
                foodFacts[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MithoPointsPage extends StatelessWidget {
  const MithoPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitho Points'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'You have 120 Mitho Points!\n\nUse them for exciting rewards.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  // Only three main support members
  static final List<_SupportMember> _team = [
    _SupportMember(
      name: 'Aadarsha Sharma',
      role: 'Lead Developer',
      image: 'assets/homepage_images/aadarshaaaaaaaa.png',
    ),
    _SupportMember(
      name: 'Prof. Sir',
      role: 'Project Supervisor',
      image: 'assets/homepage_images/sir.png',
    ),
    _SupportMember(
      name: 'Softwarica College',
      role: 'Institution',
      image: 'assets/homepage_images/softwaricaa.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE0B2), // light orange
              Color(0xFFE3F2FD), // light blue
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meet Our Support Team',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                // Responsive vertical cards for each member
                ..._team.map((member) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              member.image,
                              height: 64,
                              width: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member.role,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Colors.deepOrange,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                Text(
                  'FAQs',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                _FaqItem(question: 'How do I place an order?'),
                _FaqItem(question: 'How can I track my delivery?'),
                _FaqItem(question: 'What if I face payment issues?'),
                _FaqItem(question: 'How do I contact support?'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Contact us: support@mithobites.com',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportMember {
  final String name;
  final String role;
  final String image;
  const _SupportMember({required this.name, required this.role, required this.image});
}

class _SupportCard extends StatelessWidget {
  final _SupportMember member;
  const _SupportCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              member.image,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            member.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            member.role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Colors.deepOrange,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  const _FaqItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.help_outline, color: Colors.deepOrange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class GiveFeedbacksPage extends StatelessWidget {
  const GiveFeedbacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => serviceLocator<OrderViewModel>()..fetchOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Give Feedbacks'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Consumer<OrderViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.error != null) {
              return Center(child: Text('Error: ${viewModel.error}'));
            }
            final receivedOrders =
                viewModel.orders
                    .where((order) => order.orderStatus == 'received')
                    .toList();
            if (receivedOrders.isEmpty) {
              return const Center(
                child: Text('No received orders to give feedback on.'),
              );
            }
            return ListView.builder(
              itemCount: receivedOrders.length,
              itemBuilder: (context, index) {
                final order = receivedOrders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id?.substring(order.id!.length - 5) ?? ''} • Placed: ${order.orderDate.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...order.items.whereType<Map<String, dynamic>>().map((
                          item,
                        ) {
                          final productId =
                              item['productId'] is Map
                                  ? item['productId']['_id']?.toString() ?? ''
                                  : item['productId']?.toString() ?? '';
                          final productName =
                              item['productName']?.toString() ?? 'Food Item';
                          final productImage = item['productImage']?.toString();
                          final restaurantName =
                              item['restaurantName']?.toString();
                          return ListTile(
                            leading:
                                productImage != null && productImage.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        productImage,
                                        height: 48,
                                        width: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.image,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                      ),
                                    )
                                    : const Icon(
                                      Icons.fastfood,
                                      size: 48,
                                      color: Colors.deepOrange,
                                    ),
                            title: Text(productName),
                            subtitle:
                                restaurantName != null &&
                                        restaurantName.isNotEmpty
                                    ? Text(
                                      'From: $restaurantName',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    )
                                    : null,
                            trailing: ChangeNotifierProvider(
                              create:
                                  (_) => serviceLocator<FeedbackViewModel>(),
                              child: FeedbackButton(
                                userId: order.userId,
                                productId: productId,
                                productName: productName,
                                productImage: productImage,
                                restaurantName: restaurantName,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false,
            onChanged: (value) {},
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: true,
            onChanged: (value) {},
            secondary: const Icon(Icons.notifications_active),
          ),
        ],
      ),
    );
  }
}

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update My Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Text(
          'Profile update coming soon!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

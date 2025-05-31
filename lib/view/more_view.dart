import 'package:flutter/material.dart';

class MoreView extends StatelessWidget {
  const MoreView({Key? key}) : super(key: key);

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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const OrderHistoryPage())),
          ),
          _buildMoreItem(
            icon: Icons.local_offer,
            title: 'Offers & Coupons',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const OffersPage())),
            iconColor: Colors.green.shade100,
          ),
          _buildMoreItem(
            icon: Icons.stars,
            title: 'Mitho Points',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MithoPointsPage())),
            iconColor: Colors.purple.shade100,
          ),
          _buildMoreItem(
            icon: Icons.support_agent,
            title: 'Help & Support',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage())),
            iconColor: Colors.blue.shade100,
          ),
          _buildMoreItem(
            icon: Icons.share,
            title: 'Refer & Earn',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ReferEarnPage())),
            iconColor: Colors.amber.shade100,
          ),
          _buildMoreItem(
            icon: Icons.settings,
            title: 'App Settings',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AppSettingsPage())),
            iconColor: Colors.teal.shade100,
          ),
          const SizedBox(height: 20),
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
      appBar: AppBar(title: const Text('Order History'), backgroundColor: Colors.deepOrange),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => Card(
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

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers & Coupons'), backgroundColor: Colors.deepOrange),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              title: Text('50% OFF on your first order'),
              subtitle: Text('Use code: FIRST50'),
              trailing: Icon(Icons.card_giftcard),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Free delivery on orders above Rs.500'),
              subtitle: Text('No coupon needed'),
              trailing: Icon(Icons.delivery_dining),
            ),
          ),
        ],
      ),
    );
  }
}

class MithoPointsPage extends StatelessWidget {
  const MithoPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mitho Points'), backgroundColor: Colors.deepOrange),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('FAQs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('- How do I place an order?'),
            Text('- How can I track my delivery?'),
            Text('- What if I face payment issues?'),
            SizedBox(height: 20),
            Text('Contact us: support@mithobites.com', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ReferEarnPage extends StatelessWidget {
  const ReferEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refer & Earn'), backgroundColor: Colors.deepOrange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Invite your friends & earn rewards!\n\nShare your referral code:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange.shade100,
              ),
              child: const Text('MITHO123', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            ),
          ],
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
      appBar: AppBar(title: const Text('App Settings'), backgroundColor: Colors.deepOrange),
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
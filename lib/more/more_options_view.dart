import 'package:flutter/material.dart';

class MoreOptionsView extends StatelessWidget {
  const MoreOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("More"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _buildOptionCard(
              context,
              icon: Icons.settings,
              title: "Settings",
              subtitle: "Manage app preferences",
              onTap: () {
                // Navigate to settings
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.help_outline,
              title: "Help & Support",
              subtitle: "Get assistance or FAQs",
              onTap: () {
                // Navigate to help
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.history,
              title: "Order History",
              subtitle: "View your past orders",
              onTap: () {
                // Navigate to history
              },
            ),
            _buildOptionCard(
              context,
              icon: Icons.info_outline,
              title: "About Us",
              subtitle: "Know more about Mitho-Bites Nepal",
              onTap: () {
                // Navigate to about
              },
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1),
            const SizedBox(height: 12),
            _buildLogoutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.deepOrange.withOpacity(0.1),
          child: Icon(icon, color: Colors.deepOrange, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.red.shade50,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.red.withOpacity(0.1),
          child: const Icon(Icons.logout, color: Colors.red, size: 24),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.red,
            fontFamily: 'Montserrat',
          ),
        ),
        subtitle: const Text(
          "Sign out of your account",
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(Icons.exit_to_app, color: Colors.red, size: 20),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    // TODO: Add logout logic
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

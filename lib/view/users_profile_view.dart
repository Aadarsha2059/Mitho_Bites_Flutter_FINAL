import 'package:flutter/material.dart';
import 'package:fooddelivery_b/model/users_profile_model.dart';
import 'package:fooddelivery_b/view/sign_in_view.dart';
import 'dashboard_view.dart';

class UserProfileView extends StatelessWidget {
  final UserProfileModel model = UserProfileModel();

  UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Order view not implemented yet."),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/aadarsha.jpeg'),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Hi there, Aadarsha!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            TextButton.icon(
              onPressed: () => model.signOut(context, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SignInPage()),
                );
              }),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
            const Divider(thickness: 1, indent: 20, endIndent: 20),
            const SizedBox(height: 10),
            ProfileField(
              icon: Icons.person,
              label: "Name",
              controller: model.nameController,
            ),
            ProfileField(
              icon: Icons.email,
              label: "Email",
              controller: model.emailController,
              inputType: TextInputType.emailAddress,
            ),
            ProfileField(
              icon: Icons.phone,
              label: "Mobile No",
              controller: model.mobileController,
              inputType: TextInputType.phone,
            ),
            ProfileField(
              icon: Icons.home,
              label: "Address",
              controller: model.addressController,
            ),
            ProfileField(
              icon: Icons.lock,
              label: "Password",
              controller: model.passwordController,
              obscureText: true,
            ),
            ProfileField(
              icon: Icons.lock_outline,
              label: "Confirm Password",
              controller: model.confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Profile"),
              onPressed: () => model.saveProfile(context, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardView()),
                );
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 219, 217, 222),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType inputType;

  const ProfileField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

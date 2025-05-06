import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void _signup() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      _showAlertDialog(
        title: "Missing Fields",
        content: "Please fill in all the fields to sign up.",
      );
      return;
    }

    if (password.length < 6) {
      _showAlertDialog(
        title: "Weak Password",
        content: "Password must be at least 6 characters long.",
      );
      return;
    }

    if (password != confirmPassword) {
      _showAlertDialog(
        title: "Password Mismatch",
        content: "Passwords do not match. Please retype them correctly.",
      );
      return;
    }

    // For now, just print the values
    print("Signup with: $username, $phone, $address");
  }

  void _showAlertDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    print("Navigate back to Login Page");
    Navigator.pop(context); // Assuming you push this screen from login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffB81736), Color(0xff281537)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Welcome!\nCreate Account',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // White Container
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo.png'),
                        radius: 30,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Heading
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff281537),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Mitho_Bites Nepal",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffB81736),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Username
                    TextField(
                      controller: _usernameController,
                      decoration: _inputDecoration("Username", Icons.person),
                    ),
                    SizedBox(height: 20),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Password", Icons.lock),
                    ),
                    SizedBox(height: 20),

                    // Confirm Password
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: _inputDecoration("Confirm Password", Icons.lock_outline),
                    ),
                    SizedBox(height: 20),

                    // Phone
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration("Phone", Icons.phone),
                    ),
                    SizedBox(height: 20),

                    // Address
                    TextField(
                      controller: _addressController,
                      decoration: _inputDecoration("Address", Icons.home),
                    ),
                    SizedBox(height: 30),

                    // Sign Up Button
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xffB81736), Color(0xff281537)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Navigate to Login
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: Text(
                              "Back to Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fooddelivery_b/model/sign_up_model.dart';
import 'package:fooddelivery_b/features/chatbot/presentation/view/chat_bot_view.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpModel _model;

  @override
  void initState() {
    super.initState();
    _model = SignUpModel(context: context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffB81736), Color(0xff281537)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
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

          // White card
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
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
                    Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo.png'),
                        radius: 30,
                      ),
                    ),
                    SizedBox(height: 20),
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

                    // Form fields
                    TextField(
                      controller: _model.fullNameController,
                      decoration: _inputDecoration("Full Name", Icons.person_outline),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _model.usernameController,
                      decoration: _inputDecoration("Username", Icons.person),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _model.passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Password", Icons.lock),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _model.confirmPasswordController,
                      obscureText: true,
                      decoration: _inputDecoration("Confirm Password", Icons.lock_outline),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _model.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration("Phone", Icons.phone),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _model.addressController,
                      decoration: _inputDecoration("Address", Icons.home),
                    ),
                    SizedBox(height: 30),

                    // Sign up button
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
                        onPressed: _model.signup,
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

                    // Navigate to login
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
                            onTap: _model.navigateToLogin,
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
          
          // Chatbot
          const ChatBotView(),
        ],
      ),
    );
  }
}

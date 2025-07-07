import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/core/common/widgets/loading_overlay.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:fooddelivery_b/features/chatbot/presentation/view/chat_bot_view.dart';
import 'package:fooddelivery_b/features/home/presentation/view/home_view.dart';
import 'package:local_auth/local_auth.dart';
import 'package:dio/dio.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'aadarsha2059');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LoginViewModel>(),
      child: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeView(loginViewModel: context.read<LoginViewModel>()),
              ),
            );
          }
        },
        child: BlocBuilder<LoginViewModel, LoginState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state.isLoading,
              child: Scaffold(
                body: SizedBox.expand(
                  child: Stack(
                    children: [
                      // Gradient Background
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffB81736), Color(0xff281537)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Header
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 20,
                          ),
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Hello\nSign in!',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // White Container for Form
                      Padding(
                        padding: const EdgeInsets.only(top: 180),
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/logo.png',
                                      ),
                                      radius: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Login Page',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff281537),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Mitho_Bites Nepal',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xffB81736),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // Username
                                  TextFormField(
                                    key: const ValueKey('username'),
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      prefixIcon: const Icon(Icons.person),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) return 'Please enter username';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password
                                  TextFormField(
                                    key: const ValueKey('password'),
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock),
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () async {
                                        final emailController = TextEditingController();
                                        await showDialog<String>(
                                          context: context,
                                          builder: (context) => Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(24),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(24),
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xffB81736), Color(0xff281537)],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.08),
                                                    blurRadius: 16,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.lock_reset, color: Colors.white, size: 32),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          'Forgot Password?',
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    'Enter your registered email address and we\'ll send you a password reset link.',
                                                    style: TextStyle(color: Colors.white70, fontSize: 15),
                                                  ),
                                                  const SizedBox(height: 18),
                                                  TextField(
                                                    controller: emailController,
                                                    keyboardType: TextInputType.emailAddress,
                                                    style: const TextStyle(color: Colors.white),
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      labelStyle: const TextStyle(color: Colors.white70),
                                                      prefixIcon: const Icon(Icons.email, color: Colors.white70),
                                                      filled: true,
                                                      fillColor: Colors.white.withOpacity(0.08),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(16),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 24),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          foregroundColor: const Color(0xffB81736),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                                        ),
                                                        icon: const Icon(Icons.send),
                                                        label: const Text('Send Reset Link', style: TextStyle(fontWeight: FontWeight.bold)),
                                                        onPressed: () async {
                                                          final email = emailController.text.trim();
                                                          if (email.isEmpty || !email.contains('@')) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(content: Text('Please enter a valid email.')),
                                                            );
                                                            return;
                                                          }
                                                          try {
                                                            final dio = Dio();
                                                            final response = await dio.post(
                                                              'http://10.0.2.2:5050/api/auth/forgot-password',
                                                              data: {'email': email},
                                                            );
                                                            Navigator.pop(context);
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                title: const Text('Check Your Email'),
                                                                content: Text(response.data['message'] ?? 'If an account with this email exists, you will receive a password reset link.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () => Navigator.pop(context),
                                                                    child: const Text('OK'),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            Navigator.pop(context);
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                title: const Text('Error'),
                                                                content: const Text('Failed to send reset link. Please try again.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () => Navigator.pop(context),
                                                                    child: const Text('OK'),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Forgot Password?'),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Login Button
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
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginViewModel>().add(
                                            LoginWithUsernameAndPasswordEvent(
                                              context: context,
                                              username: _usernameController.text.trim(),
                                              password: _passwordController.text.trim(),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Fingerprint Login Button
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: IconButton(
                                      icon: const Icon(Icons.fingerprint, size: 40, color: Color(0xffB81736)),
                                      tooltip: 'Login with Fingerprint',
                                      onPressed: () async {
                                        final LocalAuthentication auth = LocalAuthentication();
                                        bool canCheck = await auth.canCheckBiometrics;
                                        bool isAvailable = await auth.isDeviceSupported();
                                        if (!canCheck || !isAvailable) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Fingerprint not available on this device')),
                                          );
                                          return;
                                        }
                                        try {
                                          bool didAuthenticate = await auth.authenticate(
                                            localizedReason: 'Please authenticate to login',
                                            options: const AuthenticationOptions(biometricOnly: true),
                                          );
                                          if (didAuthenticate) {
                                            // Navigate to HomeView
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => HomeView(loginViewModel: context.read<LoginViewModel>()),
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Fingerprint authentication successful!')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Fingerprint authentication failed.')),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: \\${e.toString()}')),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Register Prompt
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Don't have an account?",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context.read<LoginViewModel>().add(
                                              NavigateToRegisterViewEvent(
                                                context: context,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Sign Up",
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
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Chatbot
                      const ChatBotView(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

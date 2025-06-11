import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffB81736), Color(0xff281537)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Top header with title and optional info button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hello\nSign in!',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //  add info button if needed, or remove
                    // IconButton(
                    //   icon: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 30),
                    //   tooltip: 'About Us',
                    //   onPressed: () {}, // Add navigation if needed
                    // ),
                  ],
                ),
              ),
            ),
            // White curved container with the form
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
                  child: BlocConsumer<LoginViewModel, LoginState>(
                    listener: (context, state) {
                      if (state.isSuccess) {
                        // Handle success if needed, e.g. navigate
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
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
                            TextFormField(
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
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Enter username' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
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
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Enter password' : null,
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  // You can add forgot password navigation here
                                  // For example:
                                  // Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 81, 227, 253),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [Color(0xffB81736), Color(0xff281537)],
                                ),
                              ),
                              child: state.isLoading
                                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<LoginViewModel>(context).add(
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
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 30),
                            const Center(child: Text("We can login with other options as well..")),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.facebook, color: Color(0xff3b5998)),
                                  label: const Text("Facebook"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xfff5f6f7),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                                  label: const Text("Google"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff949393),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<LoginViewModel>(context).add(
                                        NavigateToRegisterViewEvent(context: context),
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
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

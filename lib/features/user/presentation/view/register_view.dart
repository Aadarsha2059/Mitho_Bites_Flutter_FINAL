import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(context: context),
      child: Scaffold(
        body: Stack(
          children: [
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
                  child: Consumer<RegisterViewModel>(
                    builder: (context, vm, _) {
                      final state = vm.state;

                      return Column(
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

                          if (state.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                state.errorMessage!,
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),

                          // Form fields
                          TextField(
                            onChanged: (v) => vm.onEvent(FullNameChanged(v)),
                            decoration: _inputDecoration("Full Name", Icons.person_outline),
                          ),
                          SizedBox(height: 20),

                          TextField(
                            onChanged: (v) => vm.onEvent(UsernameChanged(v)),
                            decoration: _inputDecoration("Username", Icons.person),
                          ),
                          SizedBox(height: 20),

                          TextField(
                            onChanged: (v) => vm.onEvent(PasswordChanged(v)),
                            obscureText: true,
                            decoration: _inputDecoration("Password", Icons.lock),
                          ),
                          SizedBox(height: 20),

                          TextField(
                            onChanged: (v) => vm.onEvent(ConfirmPasswordChanged(v)),
                            obscureText: true,
                            decoration: _inputDecoration("Confirm Password", Icons.lock_outline),
                          ),
                          SizedBox(height: 20),

                          TextField(
                            onChanged: (v) => vm.onEvent(PhoneChanged(v)),
                            keyboardType: TextInputType.phone,
                            decoration: _inputDecoration("Phone", Icons.phone),
                          ),
                          SizedBox(height: 20),

                          TextField(
                            onChanged: (v) => vm.onEvent(AddressChanged(v)),
                            decoration: _inputDecoration("Address", Icons.home),
                          ),
                          SizedBox(height: 30),

                          // Sign up button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: state.isSubmitting ? null : () => vm.onEvent(SubmitRegistration()),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xffB81736), Color(0xff281537)],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: state.isSubmitting
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          "Sign Up",
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                ),
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
                                  onTap: () => Navigator.pop(context),
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

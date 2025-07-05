import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/update_profile/profile_view_model.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/update_profile/profile_state.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/update_profile/profile_event.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';

class UpdateProfilePageeWrapper extends StatelessWidget {
  const UpdateProfilePageeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = ProfileViewModel();
        vm.onEvent(LoadProfile());
        return vm;
      },
      child: const UpdateProfilePagee(),
    );
  }
}

class UpdateProfilePagee extends StatefulWidget {
  const UpdateProfilePagee({super.key});

  @override
  State<UpdateProfilePagee> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePagee> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  UserEntity? _originalUser;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _controllersInitialized = false;
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    if (_originalUser == null) return false;
    return _fullnameController.text.trim() != _originalUser!.fullname ||
        _usernameController.text.trim() != _originalUser!.username ||
        _phoneController.text.trim() != _originalUser!.phone ||
        _addressController.text.trim() != _originalUser!.address ||
        _emailController.text.trim() != _originalUser!.email ||
        _passwordController.text.trim().isNotEmpty;
  }

  void _fillControllers(UserEntity user) {
    _fullnameController.text = user.fullname;
    _usernameController.text = user.username;
    _phoneController.text = user.phone;
    _addressController.text = user.address;
    _emailController.text = user.email;
    _originalUser = user;
    _controllersInitialized = true;
  }

  void _onSave(UserEntity oldUser) {
    if (!_hasChanges()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to save.')),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      final newPassword = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      if (newPassword.isNotEmpty && newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      final updatedUser = UserEntity(
        userId: oldUser.userId,
        fullname: _fullnameController.text.trim(),
        username: _usernameController.text.trim(),
        password: newPassword.isNotEmpty ? newPassword : oldUser.password,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
      );
      Provider.of<ProfileViewModel>(context, listen: false)
          .onEvent(UpdateProfile(updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        final state = vm.state;
        if (state is ProfileLoading || state is ProfileInitial) {
          return Scaffold(
            appBar: AppBar(title: const Text('Update Profile')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Update Profile')),
            body: Center(child: Text(state.message)),
          );
        } else if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
          final user = state is ProfileLoaded
              ? state.user
              : (state as ProfileUpdateSuccess).user;
          if (!_controllersInitialized) {
            _fillControllers(user);
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
              _passwordController.clear();
              _confirmPasswordController.clear();
            }
          });
          return Scaffold(
            appBar: AppBar(
              title: const Text('Update Profile'),
              backgroundColor: Colors.deepOrange,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFE0B2), Color(0xFFFFF3E0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.deepOrange.shade100,
                              child: Icon(Icons.person, size: 48, color: Colors.deepOrange.shade400),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Edit your profile',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange.shade700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _fullnameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: const Icon(Icons.verified_user),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                prefixIcon: const Icon(Icons.home),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'New Password (leave blank to keep unchanged)',
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              obscureText: true,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                                filled: true,
                                fillColor: Colors.orange.shade50,
                              ),
                              obscureText: true,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.save, color: Colors.white),
                                label: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                onPressed: _hasChanges() ? () => _onSave(user) : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _hasChanges() ? Colors.deepOrange : Colors.orange.shade200,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  elevation: 4,
                                ),
                              ),
                            ),
                            if (state is ProfileUpdateSuccess)
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Text('Profile updated successfully!', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is ProfileUpdating) {
          return Scaffold(
            appBar: AppBar(title: const Text('Update Profile')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
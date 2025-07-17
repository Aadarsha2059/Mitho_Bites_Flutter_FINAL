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
  State<UpdateProfilePagee> createState() => _UpdateProfilePageeState();
}

class _UpdateProfilePageeState extends State<UpdateProfilePagee> {
  UserEntity? _originalUser;
  String? _editingField;
  String _fieldValue = '';
  String _currentPassword = '';
  String _successMsg = '';
  String _errorMsg = '';
  bool _showPassword = false;
  final _scrollController = ScrollController();

  void _startEdit(String field, UserEntity user) {
    setState(() {
      _editingField = field;
      switch (field) {
        case 'fullname':
          _fieldValue = user.fullname;
          break;
        case 'username':
          _fieldValue = user.username;
          break;
        case 'email':
          _fieldValue = user.email;
          break;
        case 'phone':
          _fieldValue = user.phone;
          break;
        case 'address':
          _fieldValue = user.address;
          break;
        case 'password':
          _fieldValue = '';
          break;
        default:
          _fieldValue = '';
      }
      _currentPassword = '';
      _successMsg = '';
      _errorMsg = '';
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingField = null;
      _fieldValue = '';
      _currentPassword = '';
      _successMsg = '';
      _errorMsg = '';
    });
  }

  void _submitEdit(UserEntity user) {
    setState(() {
      _successMsg = '';
      _errorMsg = '';
    });
    if (_editingField == null) return;
    if ((_editingField == 'email' || _editingField == 'password') && _currentPassword.isEmpty) {
      setState(() { _errorMsg = 'Current password is required for sensitive changes.'; });
      return;
    }
    if (_editingField == 'password' && _fieldValue.length < 6) {
      setState(() { _errorMsg = 'Password must be at least 6 characters.'; });
      return;
    }
    if (_editingField == 'phone') {
      final phoneNum = int.tryParse(_fieldValue);
      if (_fieldValue.isEmpty || phoneNum == null || _fieldValue.length < 7) {
        setState(() { _errorMsg = 'Please enter a valid phone number.'; });
        return;
      }
    }
    UserEntity updated;
    switch (_editingField) {
      case 'fullname':
        updated = UserEntity(
          userId: user.userId,
          fullname: _fieldValue,
          username: user.username,
          password: '',
          phone: user.phone,
          address: user.address,
          email: user.email,
        );
        break;
      case 'username':
        updated = UserEntity(
          userId: user.userId,
          fullname: user.fullname,
          username: _fieldValue,
          password: '',
          phone: user.phone,
          address: user.address,
          email: user.email,
        );
        break;
      case 'email':
        updated = UserEntity(
          userId: user.userId,
          fullname: user.fullname,
          username: user.username,
          password: '',
          phone: user.phone,
          address: user.address,
          email: _fieldValue,
        );
        break;
      case 'phone':
        updated = UserEntity(
          userId: user.userId,
          fullname: user.fullname,
          username: user.username,
          password: '',
          phone: _fieldValue,
          address: user.address,
          email: user.email,
        );
        break;
      case 'address':
        updated = UserEntity(
          userId: user.userId,
          fullname: user.fullname,
          username: user.username,
          password: '',
          phone: user.phone,
          address: _fieldValue,
          email: user.email,
        );
        break;
      case 'password':
        updated = UserEntity(
          userId: user.userId,
          fullname: user.fullname,
          username: user.username,
          password: _fieldValue,
          phone: user.phone,
          address: user.address,
          email: user.email,
        );
        break;
      default:
        return;
    }
    if (_editingField == 'email' || _editingField == 'password') {
      Provider.of<ProfileViewModel>(context, listen: false).onEvent(UpdateProfile(updated), currentPassword: _currentPassword);
    } else {
      Provider.of<ProfileViewModel>(context, listen: false).onEvent(UpdateProfile(updated));
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
          final user = state is ProfileLoaded ? state.user : (state as ProfileUpdateSuccess).user;
          _originalUser ??= user;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state is ProfileUpdateSuccess) {
              setState(() {
                _successMsg = 'Profile updated successfully!';
                _editingField = null;
                _fieldValue = '';
                _currentPassword = '';
              });
            } else if (state is ProfileError) {
              setState(() { _errorMsg = state.message; });
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 480,
                          minWidth: 260,
                        ),
                        child: Card(
                          elevation: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.deepOrange.shade100,
                                  child: Icon(Icons.person, size: 48, color: Colors.deepOrange.shade400),
                                ),
                                const SizedBox(height: 16),
                                Text('Edit your profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade700)),
                                const SizedBox(height: 24),
                                ...['fullname', 'username', 'email', 'phone', 'address', 'password'].map((field) {
                                  final label = {
                                    'fullname': 'Full Name',
                                    'username': 'Username',
                                    'email': 'Email',
                                    'phone': 'Phone',
                                    'address': 'Address',
                                    'password': 'Password',
                                  }[field]!;
                                  final isEditing = _editingField == field;
                                  String value = '';
                                  switch (field) {
                                    case 'fullname':
                                      value = user.fullname;
                                      break;
                                    case 'username':
                                      value = user.username;
                                      break;
                                    case 'email':
                                      value = user.email;
                                      break;
                                    case 'phone':
                                      value = user.phone;
                                      break;
                                    case 'address':
                                      value = user.address;
                                      break;
                                    case 'password':
                                      value = '••••••••';
                                      break;
                                    default:
                                      value = '';
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: isEditing
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepOrange)),
                                                    const SizedBox(height: 6),
                                                    TextField(
                                                      obscureText: field == 'password' && !_showPassword,
                                                      keyboardType: field == 'email' ? TextInputType.emailAddress : TextInputType.text,
                                                      decoration: InputDecoration(
                                                        hintText: 'Enter $label',
                                                        suffixIcon: field == 'password'
                                                            ? IconButton(
                                                                icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                                                                onPressed: () => setState(() => _showPassword = !_showPassword),
                                                              )
                                                            : null,
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                        filled: true,
                                                        fillColor: Colors.orange.shade50,
                                                      ),
                                                      onChanged: (v) => setState(() => _fieldValue = v),
                                                      controller: TextEditingController(text: _fieldValue),
                                                    ),
                                                    if (field == 'email' || field == 'password') ...[
                                                      const SizedBox(height: 8),
                                                      TextField(
                                                        obscureText: true,
                                                        decoration: InputDecoration(
                                                          hintText: 'Current Password',
                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                          filled: true,
                                                          fillColor: Colors.orange.shade50,
                                                        ),
                                                        onChanged: (v) => setState(() => _currentPassword = v),
                                                      ),
                                                    ],
                                                    Row(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () => _submitEdit(user),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.deepOrange,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          ),
                                                          child: const Text('Save'),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        OutlinedButton(
                                                          onPressed: _cancelEdit,
                                                          style: OutlinedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          ),
                                                          child: const Text('Cancel'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Expanded(child: Text('$label: $value', style: const TextStyle(fontSize: 16))),
                                                    IconButton(
                                                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                                                      onPressed: () => _startEdit(field, user),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                if (_successMsg.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 18),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.green.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.green),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(_successMsg, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                                if (_errorMsg.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 18),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.red.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(_errorMsg, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600))),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
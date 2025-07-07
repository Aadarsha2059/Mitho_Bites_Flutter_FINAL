import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/model/users_profile_model.dart';

void main() {
  group('UserProfile', () {
    test('Default values are correct', () {
      final user = UserProfile(
        name: '',
        username: '',
        mobile: '',
        address: '',
      );
      expect(user.password, '');
      expect(user.confirmPassword, '');
    });

    test('Can assign and retrieve values', () {
      final user = UserProfile(
        name: 'Test User',
        username: 'testuser',
        mobile: '1234567890',
        address: 'Kathmandu',
        password: 'pass',
        confirmPassword: 'pass',
      );
      expect(user.name, 'Test User');
      expect(user.username, 'testuser');
      expect(user.mobile, '1234567890');
      expect(user.address, 'Kathmandu');
      expect(user.password, 'pass');
      expect(user.confirmPassword, 'pass');
    });
  });
} 
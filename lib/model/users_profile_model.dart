class UserProfile {
  String name;
  String username;
  String mobile;
  String address;
  String password;
  String confirmPassword;

  UserProfile({
    required this.name,
    required this.username,
    required this.mobile,
    required this.address,
    this.password = '',
    this.confirmPassword = '',
  });
}

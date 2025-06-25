import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id', defaultValue: '')
  final String? userId;
  @JsonKey(defaultValue: '')
  final String? fullname;
  @JsonKey(defaultValue: '')
  final String? username;
  @JsonKey(defaultValue: '')
  final String? password;
  @JsonKey(defaultValue: '')
  final String? confirmpassword;
  @JsonKey(defaultValue: 0)
  final int? phone;
  @JsonKey(defaultValue: '')
  final String? address;
  @JsonKey(defaultValue: '')
  final String? email;

  const UserApiModel({
    this.userId,
    this.fullname,
    this.username,
    this.password,
    this.confirmpassword,
    this.phone,
    this.address,
    this.email,
  });

  const UserApiModel.empty()
    : userId = '',
      fullname = '',
      username = '',
      password = '',
      confirmpassword = '',
      phone = 0,
      address = '',
      email = '';

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['_id']?.toString(),
      fullname: json['fullname']?.toString(),
      username: json['username']?.toString(),
      password: json['password']?.toString(),
      confirmpassword: json['confirmpassword']?.toString(),
      phone:
          json['phone'] is String ? int.tryParse(json['phone']) : json['phone'],
      address: json['address']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'fullname': fullname,
      'username': username,
      'password': password,
      'confirmpassword': confirmpassword,
      'phone': phone,
      'address': address,
      'email': email,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullname: fullname ?? '',
      username: username ?? '',
      password: password ?? '',
      phone: phone?.toString() ?? '',
      address: address ?? '',
      email: email ?? '',
    );
  }

  static UserApiModel fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      fullname: entity.fullname,
      username: entity.username,
      password: entity.password,
      confirmpassword: entity.password,
      phone: int.tryParse(entity.phone) ?? 0,
      address: entity.address,
      email: entity.email,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullname,
    username,
    password,
    confirmpassword,
    phone,
    address,
    email,
  ];
}

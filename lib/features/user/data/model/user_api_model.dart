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
  final String? phone;
  @JsonKey(defaultValue: '')
  final String? address;
  @JsonKey(defaultValue: '')
  final String? email;

  const UserApiModel({
    this.userId,
    this.fullname,
    this.username,
    this.password,
    this.phone,
    this.address,
    this.email,
  });

  const UserApiModel.empty()
    : userId = '',
      fullname = '',
      username = '',
      password = '',
      phone = '',
      address = '',
      email = '';

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['_id'],
      fullname: json['fullname'],
      username: json['username'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'fullname': fullname,
      'username': username,
      'password': password,
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
      phone: phone ?? '',
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
      phone: entity.phone,
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
    phone,
    address,
    email,
  ];
}

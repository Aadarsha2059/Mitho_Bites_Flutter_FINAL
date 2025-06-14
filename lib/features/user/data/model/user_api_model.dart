import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullname;
  final String username;
  final String password;
  final String confirmpassword;
  final String phone;
  final String address;

  const UserApiModel({
    this.userId,
    required this.fullname,
    required this.username,
    required this.password,
    required this.confirmpassword,
    required this.phone,
    required this.address,
  });

  // empty constructor for default usage

  const UserApiModel.empty()
    : userId = '',
      fullname = '',
      username = '',
      password = '',
      confirmpassword = '',
      phone = '',
      address = '';

  //from json
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['_id'],
      fullname: json['fullname'],
      username: json['username'],
      password: json['password'],
      confirmpassword: json['confirmpassword'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  // to json

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'fullname': fullname,
      'username': username,
      'password': password,
      'confirmpassword': confirmpassword,
      'phone': phone,
      'address': address,
    };
  }

  //convert to entity

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullname: fullname,
      username: username,
      password: password,
      confirmpassword: confirmpassword,
      phone: phone,
      address: address,
    );
  }

  //convert from entity
  static UserApiModel fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      fullname: entity.fullname,
      username: entity.username,
      password: entity.password,
      confirmpassword: entity.confirmpassword,
      phone: entity.phone,
      address: entity.address,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    fullname,
    username,
    password,
    confirmpassword,
    phone,
    address,

  ];
}

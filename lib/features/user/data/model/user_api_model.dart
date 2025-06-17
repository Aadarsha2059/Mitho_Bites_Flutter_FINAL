import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullname;
  final String username;
  final String password;
  final String phone;
  final String address;

  const UserApiModel({
    this.userId,
    required this.fullname,
    required this.username,
    required this.password,
    required this.phone,
    required this.address,
  });

  const UserApiModel.empty()
      : userId = '',
        fullname = '',
        username = '',
        password = '',
        phone = '',
        address = '';

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['_id'],
      fullname: json['fullname'],
      username: json['username'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
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
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullname: fullname,
      username: username,
      password: password,
      phone: phone,
      address: address,
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
      ];
}

import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/user/domain/entity/user_entity.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String fullname;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String confirmpassword;
  @HiveField(5)
  final String phone;
  @HiveField(6)
  final String address;

  UserHiveModel({
    String? userId,
    required this.fullname,
    required this.username,
    required this.password,
    required this.confirmpassword,
    required this.phone,
    required this.address,
  }) : userId = userId ?? const Uuid().v4();

  // initial constructor
  const UserHiveModel.initial()
    : userId = '',
      fullname = '',
      username = '',
      password = '',
      confirmpassword = '',
      phone = '',
      address = '';

  //from entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      fullname: entity.fullname,
      username: entity.username,
      password: entity.password,
      confirmpassword: entity.confirmpassword,
      phone: entity.phone,
      address: entity.address,
    );
  }

  // to entity
  UserEntity toEntity() {
    return UserEntity(
      fullname: fullname,
      username: username,
      password: password,
      confirmpassword: confirmpassword,
      phone: phone,
      address: address,
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

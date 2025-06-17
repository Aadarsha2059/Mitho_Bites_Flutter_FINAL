import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/user/data/model/user_hive_model.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  late Box<UserHiveModel> _userBox;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/mydbb.db';
    print(path);
    Hive.init(path);

    // Register adapters only once
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTableId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    // Open box once and keep reference
    _userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
  }

  Future<void> register(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
  }

  Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  Future<List<UserHiveModel>> getAllUser() async {
    return _userBox.values.toList();
  }

  // Return null if login fails instead of throwing
  Future<UserHiveModel?> login(String username, String password) async {
    try {
      final user = _userBox.values.firstWhere(
        (element) =>
            element.username == username && element.password == password,
      );
      return user;
    } catch (e) {
      // User not found or other error
      return null;
    }
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await Hive.deleteFromDisk();
  }

  Future<void> close() async {
    await _userBox.close();
    await Hive.close();
  }
}

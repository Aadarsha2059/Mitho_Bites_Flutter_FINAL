import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/user/data/model/user_hive_model.dart';
import 'package:fooddelivery_b/features/food_category/data/model/category_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();

    
    final hiveDbDir = Directory('${directory.path}/mydbb.db');
    if (!await hiveDbDir.exists()) {
      await hiveDbDir.create(recursive: true);
    }

    Hive.init(hiveDbDir.path);

    // Register adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(CategoryHiveModelAdapter());
  }

  // User methods
  Future<void> register(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<UserHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  Future<UserHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      return box.values.firstWhere(
        (element) => element.username == username && element.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Category methods
  Future<void> saveCategories(List<CategoryHiveModel> categories) async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.clear(); // Clear existing categories
    for (var category in categories) {
      await box.put(category.categoryId, category);
    }
  }

  Future<List<CategoryHiveModel>> getAllCategories() async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    return box.values.toList();
  }

  Future<void> clearCategories() async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.clear();
  }

  Future<void> deleteCategory(String categoryId) async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.delete(categoryId);
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.categoryBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/user/data/datasource/local_datasource/user_local_datasource.dart';
import 'package:fooddelivery_b/features/user/data/datasource/remote_datasource/user_remote_datasource.dart';
import 'package:fooddelivery_b/features/user/data/repository/local_repository/user_local_repository.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_get_current_usecase.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_login_usecase.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_register_usecase.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:fooddelivery_b/features/splash/presentation/view_model/splash_screen_view_model.dart';

// Category dependencies
import 'package:fooddelivery_b/features/food_category/data/data_source/local_datasource/category_local_datasource.dart';
import 'package:fooddelivery_b/features/food_category/data/data_source/remote_datasource/category_remote_datasource.dart';
import 'package:fooddelivery_b/features/food_category/data/repository/category_repository_impl.dart';
import 'package:fooddelivery_b/features/food_category/data/repository/local_repository/category_local_repository.dart';
import 'package:fooddelivery_b/features/food_category/data/repository/remote_repository/category_remote_repository.dart';
import 'package:fooddelivery_b/features/food_category/domain/repository/category_repository.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_view_model.dart';

import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initSplashModule();
  await _initHiveService();
  await _initApiModule();
  await _initAuthModule();
  await _initCategoryModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initApiModule() async {
  //Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        UserLoginUsecase(userRepository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
  );

  // register login view model withoug homeviewmodel to avoid circular dependency

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> _initCategoryModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<CategoryLocalDatasource>(
    () => CategoryLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<CategoryLocalRepository>(
    () => CategoryLocalRepository(
      categoryLocalDatasource: serviceLocator<CategoryLocalDatasource>(),
    ),
  );

  serviceLocator.registerLazySingleton<CategoryRemoteRepository>(
    () => CategoryRemoteRepository(
      categoryRemoteDataSource: serviceLocator<CategoryRemoteDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepositoryImpl(
      localRepository: serviceLocator<CategoryLocalRepository>(),
      remoteRepository: serviceLocator<CategoryRemoteRepository>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<GetCategoriesUsecase>(
    () => GetCategoriesUsecase(
      categoryRepository: serviceLocator<ICategoryRepository>(),
    ),
  );

  // View Models
  serviceLocator.registerFactory<CategoryViewModel>(
    () => CategoryViewModel(
      getCategoriesUsecase: serviceLocator<GetCategoriesUsecase>(),
    ),
  );
}

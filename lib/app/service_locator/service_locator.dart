import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/user/data/datasource/local_datasource/user_local_datasource.dart';
import 'package:fooddelivery_b/features/user/data/repository/local_repository/user_local_repository.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_get_current_usecase.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_login_usecase.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_register_usecase.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();

  await initApiModule();
  await _initStuModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> initApiModule() async {
  //Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

Future<void> _initStuModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
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

  // serviceLocator.registerFactory(
  //   ()=> RegisterViewModel(
  //     serviceLocator<UserRegisterUsecase>(),

  //   )
  // )

  // register login view model withoug homeviewmodel to avoid circular dependency

  // serviceLocator.registerFactory(
  //   () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  // );
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/app/shared_pref/token_shared_prefs.dart';
import 'package:fooddelivery_b/features/order/domain/repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fooddelivery_b/features/menu/menu_view_model.dart';
import 'package:fooddelivery_b/features/restaurant/data/data_source/local_datasource/restaurannt_local_datasource.dart';
import 'package:fooddelivery_b/features/restaurant/data/data_source/remote_datasource/restaurant_remote_datasource.dart';
import 'package:fooddelivery_b/features/restaurant/data/repository/local_repository/restaurant_local_repository.dart';
import 'package:fooddelivery_b/features/restaurant/data/repository/remote_repository/restaurant_remote_repository.dart';
import 'package:fooddelivery_b/features/restaurant/data/repository/restaurant_repository_impl.dart';
import 'package:fooddelivery_b/features/restaurant/domain/repository/restaurant_repository.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/get_restaurants_usecase.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_view_model.dart';
import 'package:fooddelivery_b/features/user/data/datasource/local_datasource/user_local_datasource.dart';
import 'package:fooddelivery_b/features/user/data/datasource/remote_datasource/user_remote_datasource.dart';
import 'package:fooddelivery_b/features/user/domain/repository/user_repository.dart';
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

import 'package:fooddelivery_b/features/food_products/data/data_source/local_datasource/product_local_datasource.dart';
import 'package:fooddelivery_b/features/food_products/data/data_source/remote_datasource/product_remote_datasource.dart';
import 'package:fooddelivery_b/features/food_products/data/repository/local_repository/product_local_repository.dart';
import 'package:fooddelivery_b/features/food_products/data/repository/remote_repository/product_remote_repository.dart';
import 'package:fooddelivery_b/features/food_products/data/repository/product_repository_impl.dart';
import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';
import 'package:fooddelivery_b/features/food_products/domain/use_case/get_productsby_category_usecase.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_viewmodel.dart';

// Cart dependencies
import 'package:fooddelivery_b/features/cart/data/data_source/local_datasource/cart_local_datasource.dart';
import 'package:fooddelivery_b/features/cart/data/data_source/remote_datasouce/cart_remote_datasource.dart';
import 'package:fooddelivery_b/features/cart/data/repository/local_repository/cart_local_repository.dart';
import 'package:fooddelivery_b/features/cart/data/repository/remote_repository/cart_remote_repository.dart';
import 'package:fooddelivery_b/features/cart/data/repository/cart_repository_impl.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/addto_cart_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/clear_cart_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/get_all_cart_items_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/get_cartitem_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/removefrom_cart_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/save_cart_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/use_case/update_cart_usecase.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';

// Payment dependencies
import 'package:fooddelivery_b/features/payment/data/data_source/payment_datasource.dart';
import 'package:fooddelivery_b/features/payment/data/data_source/local_data_source/payment_local_datasource.dart';
import 'package:fooddelivery_b/features/payment/data/data_source/remote_data_source/payment_remote_datasource.dart';
import 'package:fooddelivery_b/features/payment/data/repository/payment_repository_impl.dart';
import 'package:fooddelivery_b/features/payment/data/repository/payment_local_repository.dart';
import 'package:fooddelivery_b/features/payment/data/repository/payment_remote_repository.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/create_order_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/get_user_orders_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/get_order_by_id_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/update_payment_status_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/create_payment_record_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/get_all_payment_records_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/save_payment_records_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/clear_payment_records_use_case.dart';
import 'package:fooddelivery_b/features/payment/presentation/view_model/payment_view_model.dart';

import 'package:fooddelivery_b/features/order/data/data_source/order_api_i_datasource.dart';
import 'package:fooddelivery_b/features/order/data/data_source/order_remote_datasource.dart';
import 'package:fooddelivery_b/features/order/data/repository/order_repository_impl.dart';
import 'package:fooddelivery_b/features/order/domain/use_case/get_orders_usecase.dart';
import 'package:fooddelivery_b/features/order/domain/use_case/update_order_status_usecase.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';

import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initSplashModule();
  await _initHiveService();
  await _initApiModule();
  await _initAuthModule();
  await _initCategoryModule();
  await _initRestaurantModule();
  await _initMenuModule();
  await _initProductModule();
  await _initCartModule();
  await _initPaymentModule();
  await _initOrderModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initApiModule() async {
  // SharedPreferences instance
  final sharedPreferences = await SharedPreferences.getInstance();

  // TokenSharedPrefs instance
  serviceLocator.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(sharedPreferences: sharedPreferences),
  );

  //Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());

  //ApiService with TokenSharedPrefs
  serviceLocator.registerLazySingleton(
    () => ApiService(serviceLocator<Dio>(), serviceLocator<TokenSharedPrefs>()),
  );
}

Future<void> _initAuthModule() async {
  // Data Sources
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(
      apiService: serviceLocator<ApiService>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // Hybrid Repository - implemented in domain layer
  serviceLocator.registerFactory<IUserRepository>(
    () => UserRepository(
      remoteDataSource: serviceLocator<UserRemoteDatasource>(),
      localDataSource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  // Use Cases - Use Hybrid Repository
  serviceLocator.registerFactory(
    () => UserLoginUsecase(userRepository: serviceLocator<IUserRepository>()),
  );

  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(userRepository: serviceLocator<IUserRepository>()),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(
      userRepository: serviceLocator<IUserRepository>(),
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

Future<void> _initRestaurantModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<RestauranntLocalDatasource>(
    () =>
        RestauranntLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerLazySingleton<RestaurantRemoteDatasource>(
    () => RestaurantRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<RestaurantLocalRepository>(
    () => RestaurantLocalRepository(
      restaurantLocalDatasource: serviceLocator<RestauranntLocalDatasource>(),
    ),
  );

  serviceLocator.registerLazySingleton<RestaurantRemoteRepository>(
    () => RestaurantRemoteRepository(
      restaurantRemoteDatasource: serviceLocator<RestaurantRemoteDatasource>(),
    ),
  );

  serviceLocator.registerLazySingleton<IRestaurantRepository>(
    () => RestaurantRepositoryImpl(
      localRepository: serviceLocator<RestaurantLocalRepository>(),
      remoteRepository: serviceLocator<RestaurantRemoteRepository>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<GetRestaurantsUsecase>(
    () => GetRestaurantsUsecase(
      restaurantRepository: serviceLocator<IRestaurantRepository>(),
    ),
  );

  // View Models
  serviceLocator.registerFactory<RestaurantViewModel>(
    () => RestaurantViewModel(
      getRestaurantsUsecase: serviceLocator<GetRestaurantsUsecase>(),
    ),
  );
}

Future<void> _initMenuModule() async {
  serviceLocator.registerFactory<MenuViewModel>(
    () => MenuViewModel(
      getCategoriesUsecase: serviceLocator<GetCategoriesUsecase>(),
    ),
  );
}

Future<void> _initProductModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<ProductLocalDatasource>(
    () => ProductLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<ProductLocalRepository>(
    () => ProductLocalRepository(
      productLocalDatasource: serviceLocator<ProductLocalDatasource>(),
    ),
  );
  serviceLocator.registerLazySingleton<ProductRemoteRepository>(
    () => ProductRemoteRepository(
      productRemoteDatasource: serviceLocator<ProductRemoteDatasource>(),
    ),
  );
  serviceLocator.registerLazySingleton<IProductRepository>(
    () => ProductRepositoryImpl(
      localRepository: serviceLocator<ProductLocalRepository>(),
      remoteRepository: serviceLocator<ProductRemoteRepository>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<GetProductsByCategoryUsecase>(
    () => GetProductsByCategoryUsecase(
      productRepository: serviceLocator<IProductRepository>(),
    ),
  );

  // View Models
  serviceLocator.registerFactory<ProductViewModel>(
    () => ProductViewModel(repository: serviceLocator<IProductRepository>()),
  );
}

Future<void> _initCartModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<CartLocalDatasource>(
    () => CartLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<CartRemoteDatasource>(
    () => CartRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<CartLocalRepository>(
    () => CartLocalRepository(
      cartLocalDatasource: serviceLocator<CartLocalDatasource>(),
    ),
  );
  serviceLocator.registerLazySingleton<CartRemoteRepository>(
    () => CartRemoteRepository(
      cartRemoteDatasource: serviceLocator<CartRemoteDatasource>(),
    ),
  );
  serviceLocator.registerLazySingleton<ICartRepository>(
    () => CartRepositoryImpl(
      localRepository: serviceLocator<CartLocalRepository>(),
      remoteRepository: serviceLocator<CartRemoteRepository>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<GetCartUsecase>(
    () => GetCartUsecase(cartRepository: serviceLocator<ICartRepository>()),
  );
  serviceLocator.registerLazySingleton<GetAllCartItemsUsecase>(
    () => GetAllCartItemsUsecase(
      cartRepository: serviceLocator<ICartRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<GetCartItemUsecase>(
    () => GetCartItemUsecase(cartRepository: serviceLocator<ICartRepository>()),
  );
  serviceLocator.registerLazySingleton<AddToCartUsecase>(
    () => AddToCartUsecase(cartRepository: serviceLocator<ICartRepository>()),
  );
  serviceLocator.registerLazySingleton<UpdateCartItemUsecase>(
    () => UpdateCartItemUsecase(
      cartRepository: serviceLocator<ICartRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<RemoveFromCartUsecase>(
    () => RemoveFromCartUsecase(
      cartRepository: serviceLocator<ICartRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<ClearCartUsecase>(
    () => ClearCartUsecase(cartRepository: serviceLocator<ICartRepository>()),
  );
  serviceLocator.registerLazySingleton<SaveCartUsecase>(
    () => SaveCartUsecase(cartRepository: serviceLocator<ICartRepository>()),
  );

  // View Models
  serviceLocator.registerLazySingleton<CartViewModel>(
    () => CartViewModel(repository: serviceLocator<ICartRepository>()),
  );
}

Future<void> _initPaymentModule() async {
  // Data Sources
  serviceLocator.registerLazySingleton<PaymentLocalDatasource>(
    () => PaymentLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<PaymentLocalRepository>(
    () => PaymentLocalRepository(
      paymentLocalDatasource: serviceLocator<PaymentLocalDatasource>(),
    ),
  );
  serviceLocator.registerLazySingleton<PaymentRemoteRepository>(
    () => PaymentRemoteRepository(
      paymentRemoteDataSource: serviceLocator<PaymentRemoteDataSource>(),
    ),
  );
  serviceLocator.registerLazySingleton<IPaymentRepository>(
    () => PaymentRepositoryImpl(
      localRepository: serviceLocator<PaymentLocalRepository>(),
      remoteRepository: serviceLocator<PaymentRemoteRepository>(),
    ),
  );

  // Use Cases
  serviceLocator.registerLazySingleton<CreateOrderUsecase>(
    () => CreateOrderUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<GetUserOrdersUsecase>(
    () => GetUserOrdersUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<GetOrderByIdUsecase>(
    () => GetOrderByIdUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<UpdatePaymentStatusUsecase>(
    () => UpdatePaymentStatusUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<CreatePaymentRecordUsecase>(
    () => CreatePaymentRecordUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<GetAllPaymentRecordsUsecase>(
    () => GetAllPaymentRecordsUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<SavePaymentRecordsUsecase>(
    () => SavePaymentRecordsUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );
  serviceLocator.registerLazySingleton<ClearPaymentRecordsUsecase>(
    () => ClearPaymentRecordsUsecase(
      paymentRepository: serviceLocator<IPaymentRepository>(),
    ),
  );

  // View Models
  serviceLocator.registerFactory<PaymentViewModel>(
    () => PaymentViewModel(
      createOrderUsecase: serviceLocator<CreateOrderUsecase>(),
      getUserOrdersUsecase: serviceLocator<GetUserOrdersUsecase>(),
      getOrderByIdUsecase: serviceLocator<GetOrderByIdUsecase>(),
      updatePaymentStatusUsecase: serviceLocator<UpdatePaymentStatusUsecase>(),
      createPaymentRecordUsecase: serviceLocator<CreatePaymentRecordUsecase>(),
      getAllPaymentRecordsUsecase:
          serviceLocator<GetAllPaymentRecordsUsecase>(),
      savePaymentRecordsUsecase: serviceLocator<SavePaymentRecordsUsecase>(),
      clearPaymentRecordsUsecase: serviceLocator<ClearPaymentRecordsUsecase>(),
    ),
  );
}

Future<void> _initOrderModule() async {
  serviceLocator.registerLazySingleton<IOrderRemoteDataSource>(
    () => OrderRemoteDataSource(apiService: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<IOrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory<GetOrdersUsecase>(
    () => GetOrdersUsecase(orderRepository: serviceLocator()),
  );

  serviceLocator.registerFactory<UpdateOrderStatusUsecase>(
    () => UpdateOrderStatusUsecase(
      orderRepository: serviceLocator<IOrderRepository>(),
    ),
  );

  serviceLocator.registerFactory<CancelOrderUsecase>(
    () => CancelOrderUsecase(orderRepository: serviceLocator<IOrderRepository>()),
  );
  serviceLocator.registerFactory<MarkOrderReceivedUsecase>(
    () => MarkOrderReceivedUsecase(orderRepository: serviceLocator<IOrderRepository>()),
  );

  serviceLocator.registerFactory<OrderViewModel>(
    () => OrderViewModel(
      getOrdersUsecase: serviceLocator<GetOrdersUsecase>(),
      updateOrderStatusUsecase: serviceLocator<UpdateOrderStatusUsecase>(),
      cancelOrderUsecase: serviceLocator<CancelOrderUsecase>(),
      markOrderReceivedUsecase: serviceLocator<MarkOrderReceivedUsecase>(),
    ),
  );
}

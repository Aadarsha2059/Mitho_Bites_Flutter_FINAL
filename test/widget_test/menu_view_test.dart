import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/menu/menu_view.dart';
import 'package:fooddelivery_b/features/menu/menu_view_model.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

class DummyGetCategoriesUsecase implements GetCategoriesUsecase {
  @override
  Future<Either<Failure, List<FoodCategoryEntity>>> call() async {
    return Right([]);
  }
}

class DummyMenuViewModel extends MenuViewModel {
  DummyMenuViewModel() : super(getCategoriesUsecase: DummyGetCategoriesUsecase());
}

class DummyCartRepository implements ICartRepository {
  @override
  Future<Either<Failure, void>> addToCart(cartItem) async => Right(null);
  @override
  Future<Either<Failure, void>> clearCart() async => Right(null);
  @override
  Future<Either<Failure, List<CartItemEntity>>> getAllCartItems() async => Right([]);
  @override
  Future<Either<Failure, CartEntity>> getCart() async => Right(CartEntity(items: []));
  @override
  Future<Either<Failure, CartItemEntity?>> getCartItem(String cartItemId) async => Right(null);
  @override
  Future<Either<Failure, void>> removeFromCart(String cartItemId) async => Right(null);
  @override
  Future<Either<Failure, void>> saveCart(cart) async => Right(null);
  @override
  Future<Either<Failure, void>> updateCartItem(String cartItemId, int quantity) async => Right(null);
}

class DummyCartViewModel extends CartViewModel {
  DummyCartViewModel() : super(repository: DummyCartRepository());
}

void main() {
  setUp(() {
    final sl = GetIt.instance;
    if (!sl.isRegistered<CartViewModel>()) {
      sl.registerFactory<CartViewModel>(() => DummyCartViewModel());
    }
    if (!sl.isRegistered<MenuViewModel>()) {
      sl.registerFactory<MenuViewModel>(() => DummyMenuViewModel());
    }
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<CartViewModel>()) {
      sl.unregister<CartViewModel>();
    }
    if (sl.isRegistered<MenuViewModel>()) {
      sl.unregister<MenuViewModel>();
    }
  });

  testWidgets('MenuView displays search bar and address text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MenuView(),
      ),
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('MenuView displays floating action button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MenuView(),
      ),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('MenuView displays category chips', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MenuView(),
      ),
    );
    expect(find.byType(Chip), findsWidgets);
  });

  testWidgets('MenuView displays product grid', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MenuView(),
      ),
    );
    expect(find.byType(GridView), findsWidgets);
  });

  testWidgets('MenuView displays top bar with avatar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MenuView(),
      ),
    );
    expect(find.byType(CircleAvatar), findsOneWidget);
  });
} 
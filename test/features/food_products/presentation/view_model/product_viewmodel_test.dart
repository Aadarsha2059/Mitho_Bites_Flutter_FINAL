import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_viewmodel.dart';
import 'package:fooddelivery_b/features/food_products/presentation/state/product_state.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_event.dart';
import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/core/error/failure.dart';

class MockProductRepository extends Mock implements IProductRepository {}

void main() {
  late MockProductRepository repository;
  late ProductViewModel viewModel;

  setUp(() {
    repository = MockProductRepository();
    viewModel = ProductViewModel(repository: repository);
  });

  final product1 = ProductsEntity(
    productId: '1',
    name: 'Burger',
    price: 100.0,
    type: 'food',
    description: 'Tasty burger',
    image: 'assets/images/burger.png',
    isAvailable: true,
  );
  final product2 = ProductsEntity(
    productId: '2',
    name: 'Pizza',
    price: 200.0,
    type: 'food',
    description: 'Cheesy pizza',
    image: 'assets/images/pizza.png',
    isAvailable: true,
  );
  final products = [product1, product2];

  test('initial state is ProductInitial', () {
    expect(viewModel.state, isA<ProductInitial>());
  });

  test('emits ProductLoading then ProductLoaded on successful LoadProductsByCategory', () async {
    when(() => repository.getProductsByCategory('cat1'))
        .thenAnswer((_) async => Right(products));

    final states = <ProductState>[];
    viewModel.addListener(() => states.add(viewModel.state));

    await viewModel.onEvent(LoadProductsByCategory('cat1'));

    expect(states[0], isA<ProductLoading>());
    expect(states[1], isA<ProductLoaded>());
    expect((states[1] as ProductLoaded).products, products);
    verify(() => repository.getProductsByCategory('cat1')).called(1);
  });

  test('emits ProductLoading then ProductError on failed LoadProductsByCategory', () async {
    when(() => repository.getProductsByCategory('cat1'))
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Error')));

    final states = <ProductState>[];
    viewModel.addListener(() => states.add(viewModel.state));

    await viewModel.onEvent(LoadProductsByCategory('cat1'));

    expect(states[0], isA<ProductLoading>());
    expect(states[1], isA<ProductError>());
    expect((states[1] as ProductError).message, 'Error');
    verify(() => repository.getProductsByCategory('cat1')).called(1);
  });

  test('emits ProductLoading then ProductLoaded on RefreshProducts', () async {
    when(() => repository.getProductsByCategory('cat1'))
        .thenAnswer((_) async => Right(products));

    final states = <ProductState>[];
    viewModel.addListener(() => states.add(viewModel.state));

    await viewModel.onEvent(RefreshProducts('cat1'));

    expect(states[0], isA<ProductLoading>());
    expect(states[1], isA<ProductLoaded>());
    expect((states[1] as ProductLoaded).products, products);
    verify(() => repository.getProductsByCategory('cat1')).called(1);
  });
}
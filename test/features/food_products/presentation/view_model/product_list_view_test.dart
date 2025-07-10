import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_list_view.dart';
import 'package:fooddelivery_b/features/food_products/presentation/state/product_state.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_viewmodel.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/presentation/state/cart_state.dart';
import 'package:fooddelivery_b/features/cart/presentation/event/cart_event.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_event.dart';

class MockProductViewModel extends Mock implements ProductViewModel {}
class MockCartViewModel extends Mock implements CartViewModel {}
class ProductEventFake extends Fake implements ProductEvent {}
class CartEventFake extends Fake implements CartEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(ProductEventFake());
    registerFallbackValue(CartEventFake());
  });

  late MockProductViewModel mockProductViewModel;
  late MockCartViewModel mockCartViewModel;

  setUp(() {
    mockProductViewModel = MockProductViewModel();
    mockCartViewModel = MockCartViewModel();
    // Mock onEvent to always return a Future<void>
    when(() => mockProductViewModel.onEvent(any())).thenAnswer((_) async {});
    // Mock state for CartViewModel (Bloc)
    when(() => mockCartViewModel.state).thenReturn(const CartInitial());
    // Mock add for cartViewModel to avoid errors
    when(() => mockCartViewModel.add(any())).thenReturn(null);
  });

  final product = ProductsEntity(
    productId: '1',
    name: 'Burger',
    price: 100.0,
    type: 'food',
    description: 'Tasty burger',
    image: '',
    isAvailable: true,
  );

  Widget buildTestable({required ProductViewModel viewModel}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductViewModel>.value(value: viewModel),
      ],
      child: MaterialApp(
        home: BlocProvider<CartViewModel>.value(
          value: mockCartViewModel,
          child: Scaffold(
            body: ProductListView(viewModel: viewModel, categoryId: 'cat1'),
          ),
        ),
      ),
    );
  }

  testWidgets('shows loading indicator when state is ProductLoading', (tester) async {
    when(() => mockProductViewModel.state).thenReturn(ProductLoading());
    await tester.pumpWidget(buildTestable(viewModel: mockProductViewModel));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows product list when state is ProductLoaded', (tester) async {
    when(() => mockProductViewModel.state).thenReturn(ProductLoaded([product]));
    await tester.pumpWidget(buildTestable(viewModel: mockProductViewModel));
    expect(find.text('Burger'), findsOneWidget);
    expect(find.text('NPR 100.0'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);
  });

  testWidgets('shows empty message when state is ProductLoaded with empty list', (tester) async {
    when(() => mockProductViewModel.state).thenReturn(ProductLoaded([]));
    await tester.pumpWidget(buildTestable(viewModel: mockProductViewModel));
    expect(find.text('No products found in this category.'), findsOneWidget);
  });

  testWidgets('shows error message when state is ProductError', (tester) async {
    when(() => mockProductViewModel.state).thenReturn(ProductError('Error loading products'));
    await tester.pumpWidget(buildTestable(viewModel: mockProductViewModel));
    expect(find.text('Error loading products'), findsOneWidget);
  });

  testWidgets('calls onAddToCart when Add to Cart button is tapped', (tester) async {
    when(() => mockProductViewModel.state).thenReturn(ProductLoaded([product]));
    await tester.pumpWidget(buildTestable(viewModel: mockProductViewModel));
    final addToCartButton = find.widgetWithText(ElevatedButton, 'Add to Cart');
    expect(addToCartButton, findsOneWidget);
    await tester.tap(addToCartButton);
    await tester.pump(); // Let the snackbar appear
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SnackBar), findsOneWidget);
    // Optionally, verify that add was called on the cart view model
    final captured = verify(() => mockCartViewModel.add(captureAny())).captured;
    expect(captured.length, greaterThan(0));
    expect(captured.first, isA<AddToCart>());
  });
}
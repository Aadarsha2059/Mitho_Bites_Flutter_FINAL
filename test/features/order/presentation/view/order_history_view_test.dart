import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/order/presentation/view/order_history_view.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';
import 'package:fooddelivery_b/features/feedbacks/presentation/view_model/feedback_view_model.dart';

class MockOrderViewModel extends Mock implements OrderViewModel {}
class MockFeedbackViewModel extends Mock implements FeedbackViewModel {}

void main() {
  setUpAll(() {
    // No fallback needed for ChangeNotifier
  });

  late MockOrderViewModel mockOrderViewModel;
  late MockFeedbackViewModel mockFeedbackViewModel;

  setUp(() {
    mockOrderViewModel = MockOrderViewModel();
    mockFeedbackViewModel = MockFeedbackViewModel();
    // Default: not loading, no error, all filter, empty orders
    when(() => mockOrderViewModel.isLoading).thenReturn(false);
    when(() => mockOrderViewModel.error).thenReturn(null);
    when(() => mockOrderViewModel.filter).thenReturn(OrderStatusFilter.all);
    when(() => mockOrderViewModel.filteredOrders).thenReturn([]);
    when(() => mockOrderViewModel.isUpdating).thenReturn(false);
    when(() => mockOrderViewModel.updateError).thenReturn(null);
  });

  OrderEntity sampleOrder({String status = 'pending'}) => OrderEntity(
    id: 'order12345',
    userId: 'user1',
    items: [
      {'productName': 'Burger'},
      {'productName': 'Pizza'},
    ],
    totalAmount: 250.0,
    deliveryAddress: null,
    deliveryInstructions: '',
    paymentMethod: 'cash',
    paymentStatus: 'pending',
    orderStatus: status,
    estimatedDeliveryTime: DateTime.now().add(const Duration(hours: 1)),
    actualDeliveryTime: null,
    orderDate: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Widget buildTestable({required OrderViewModel viewModel}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OrderViewModel>.value(value: viewModel),
        ChangeNotifierProvider<FeedbackViewModel>.value(value: mockFeedbackViewModel),
      ],
      child: const MaterialApp(
        home: OrderHistoryView(),
      ),
    );
  }

  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    when(() => mockOrderViewModel.isLoading).thenReturn(true);
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error is not null', (tester) async {
    when(() => mockOrderViewModel.error).thenReturn('Some error');
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    expect(find.textContaining('Error: Some error'), findsOneWidget);
  });

  testWidgets('shows empty message when filteredOrders is empty', (tester) async {
    when(() => mockOrderViewModel.filteredOrders).thenReturn([]);
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    expect(find.text('No orders found'), findsOneWidget);
  });

  testWidgets('shows order list when filteredOrders is not empty', (tester) async {
    when(() => mockOrderViewModel.filteredOrders).thenReturn([sampleOrder()]);
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    expect(find.textContaining('Order #'), findsOneWidget);
    expect(find.textContaining('Burger'), findsOneWidget);
    expect(find.textContaining('Total: ₹250.00'), findsOneWidget);
  });

  testWidgets('shows filter tabs and can tap to change filter', (tester) async {
    when(() => mockOrderViewModel.filteredOrders).thenReturn([sampleOrder(status: 'pending')]);
    when(() => mockOrderViewModel.filter).thenReturn(OrderStatusFilter.all);
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    expect(find.byType(ChoiceChip), findsNWidgets(OrderStatusFilter.values.length));
    await tester.tap(find.text('Pending'));
    await tester.pump();
    verify(() => mockOrderViewModel.setFilter(OrderStatusFilter.pending)).called(1);
  });

  testWidgets('shows cancel order dialog and cancels order', (tester) async {
    final order = sampleOrder(status: 'pending');
    when(() => mockOrderViewModel.filteredOrders).thenReturn([order]);
    when(() => mockOrderViewModel.isUpdating).thenReturn(false);
    when(() => mockOrderViewModel.cancelOrder(any())).thenAnswer((_) async => true);
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    // Tap the cancel button
    final cancelButton = find.widgetWithIcon(ElevatedButton, Icons.cancel);
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
    // Confirm dialog appears
    expect(find.text('Cancel Order?'), findsOneWidget);
    // Tap 'Yes, Cancel'
    await tester.tap(find.text('Yes, Cancel'));
    await tester.pumpAndSettle();
    verify(() => mockOrderViewModel.cancelOrder(order.id!)).called(1);
  });
}
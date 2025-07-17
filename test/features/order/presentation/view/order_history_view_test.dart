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
    
  });

  late MockOrderViewModel mockOrderViewModel;
  late MockFeedbackViewModel mockFeedbackViewModel;

  setUp(() {
    mockOrderViewModel = MockOrderViewModel();
    mockFeedbackViewModel = MockFeedbackViewModel();
    
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
    // Accept any ChoiceChip with label containing filter name
    expect(find.byType(ChoiceChip), findsNWidgets(OrderStatusFilter.values.length));
    await tester.tap(find.textContaining('Pending').first);
    await tester.pump();
    verify(() => mockOrderViewModel.setFilter(OrderStatusFilter.pending)).called(1);
  });

  testWidgets('shows cancel order dialog and cancels order', (tester) async {
    final order = sampleOrder(status: 'pending');
    when(() => mockOrderViewModel.filteredOrders).thenReturn([order]);
    when(() => mockOrderViewModel.isUpdating).thenReturn(false);
    when(() => mockOrderViewModel.cancelOrder(any())).thenAnswer((_) async => true);
    await tester.pumpWidget(buildTestable(viewModel: mockOrderViewModel));
    // Accept any ElevatedButton with cancel icon or label
    final cancelButton = find.widgetWithIcon(ElevatedButton, Icons.cancel).evaluate().isNotEmpty
      ? find.widgetWithIcon(ElevatedButton, Icons.cancel)
      : find.widgetWithText(ElevatedButton, 'Cancel My Order');
    expect(cancelButton, findsWidgets);
    await tester.tap(cancelButton.first);
    await tester.pumpAndSettle();
    // Accept any dialog with 'Cancel Order?' text
    expect(find.textContaining('Cancel Order?'), findsOneWidget);
    // Tap 'Yes, Cancel' or similar
    final yesCancel = find.textContaining('Yes, Cancel').evaluate().isNotEmpty
      ? find.textContaining('Yes, Cancel')
      : find.text('Yes');
    await tester.tap(yesCancel.first);
    await tester.pumpAndSettle();
    verify(() => mockOrderViewModel.cancelOrder(order.id!)).called(1);
  });
}
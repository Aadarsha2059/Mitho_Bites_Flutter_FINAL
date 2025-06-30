import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/create_order_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/get_user_orders_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/get_order_by_id_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/update_payment_status_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/create_payment_record_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/get_all_payment_records_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/save_payment_records_use_case.dart';
import 'package:fooddelivery_b/features/payment/domain/use_case/clear_payment_records_use_case.dart';
import '../state/payment_event.dart';
import '../state/payment_state.dart';

class PaymentViewModel extends Bloc<PaymentEvent, PaymentState> {
  final CreateOrderUsecase _createOrderUsecase;
  final GetUserOrdersUsecase _getUserOrdersUsecase;
  final GetOrderByIdUsecase _getOrderByIdUsecase;
  final UpdatePaymentStatusUsecase _updatePaymentStatusUsecase;
  final CreatePaymentRecordUsecase _createPaymentRecordUsecase;
  final GetAllPaymentRecordsUsecase _getAllPaymentRecordsUsecase;
  final SavePaymentRecordsUsecase _savePaymentRecordsUsecase;
  final ClearPaymentRecordsUsecase _clearPaymentRecordsUsecase;
  
  Timer? _successTimer;
  Timer? _callTimer;

  PaymentViewModel({
    required CreateOrderUsecase createOrderUsecase,
    required GetUserOrdersUsecase getUserOrdersUsecase,
    required GetOrderByIdUsecase getOrderByIdUsecase,
    required UpdatePaymentStatusUsecase updatePaymentStatusUsecase,
    required CreatePaymentRecordUsecase createPaymentRecordUsecase,
    required GetAllPaymentRecordsUsecase getAllPaymentRecordsUsecase,
    required SavePaymentRecordsUsecase savePaymentRecordsUsecase,
    required ClearPaymentRecordsUsecase clearPaymentRecordsUsecase,
  })  : _createOrderUsecase = createOrderUsecase,
        _getUserOrdersUsecase = getUserOrdersUsecase,
        _getOrderByIdUsecase = getOrderByIdUsecase,
        _updatePaymentStatusUsecase = updatePaymentStatusUsecase,
        _createPaymentRecordUsecase = createPaymentRecordUsecase,
        _getAllPaymentRecordsUsecase = getAllPaymentRecordsUsecase,
        _savePaymentRecordsUsecase = savePaymentRecordsUsecase,
        _clearPaymentRecordsUsecase = clearPaymentRecordsUsecase,
        super(const PaymentState()) {
    on<LoadPaymentData>(_onLoadPaymentData);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<SelectOnlineService>(_onSelectOnlineService);
    on<ProcessPayment>(_onProcessPayment);
    on<ShowSuccessDialog>(_onShowSuccessDialog);
    on<HideSuccessDialog>(_onHideSuccessDialog);
    on<ShowCallDialog>(_onShowCallDialog);
    on<HideCallDialog>(_onHideCallDialog);
    on<ClosePayment>(_onClosePayment);
    on<ResetPayment>(_onResetPayment);
  }

  void _onLoadPaymentData(LoadPaymentData event, Emitter<PaymentState> emit) {
    final totalItems = event.cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    emit(state.copyWith(
      cartItems: event.cartItems,
      totalAmount: event.totalAmount,
      totalItems: totalItems,
    ));
  }

  void _onSelectPaymentMethod(SelectPaymentMethod event, Emitter<PaymentState> emit) {
    emit(state.copyWith(
      selectedPaymentMethod: event.paymentMethod,
    ));
  }

  void _onSelectOnlineService(SelectOnlineService event, Emitter<PaymentState> emit) {
    emit(state.copyWith(
      selectedOnlineService: event.onlineService,
    ));
  }

  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PaymentState> emit) async {
    if (state.cartItems.isEmpty) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        errorMessage: 'Your cart is empty. Please add items before placing an order.',
      ));
      return;
    }

    emit(state.copyWith(
      isProcessing: true,
      status: PaymentStatus.processing,
      errorMessage: null,
    ));

    try {
      // Map payment method to backend enum
      final paymentMethod = state.selectedPaymentMethod == PaymentMethodType.online 
          ? 'online' 
          : 'cash';

      // Prepare order data for backend - backend expects deliveryInstructions and paymentMethod
      // The backend will automatically get cart items from the user's cart
      final orderData = {
        'deliveryInstructions': event.deliveryInstructions,
        'paymentMethod': paymentMethod,
      };

      print('🔄 PaymentViewModel: Processing payment with data: $orderData');
      print('🔄 PaymentViewModel: Cart items count: ${state.cartItems.length}');
      print('🔄 PaymentViewModel: Total amount: ${state.totalAmount}');

      final result = await _createOrderUsecase.execute(orderData);

      print('🔄 PaymentViewModel: Result received: $result');
      print('🔄 PaymentViewModel: Result is Left: ${result.isLeft()}');
      print('🔄 PaymentViewModel: Result is Right: ${result.isRight()}');

      result.fold(
        (failure) {
          print('❌ PaymentViewModel: Payment failed - ${failure.message}');
          emit(state.copyWith(
            isProcessing: false,
            status: PaymentStatus.error,
            errorMessage: failure.message,
          ));
        },
        (order) {
          print('✅ PaymentViewModel: Payment successful - Order data: $order');
          final orderId = order['_id'] ?? order['id'] ?? 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
          print('✅ PaymentViewModel: Order ID extracted: $orderId');
          
          emit(state.copyWith(
            isProcessing: false,
            status: PaymentStatus.success,
            orderId: orderId,
          ));
          
          print('✅ PaymentViewModel: State updated to success, orderId: $orderId');
          
          // Show success dialog after a short delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (!isClosed) {
              print('🎉 PaymentViewModel: Adding ShowSuccessDialog event');
              add(ShowSuccessDialog(orderId));
            }
          });
        },
      );
    } catch (e) {
      print('❌ PaymentViewModel: Payment error - $e');
      emit(state.copyWith(
        isProcessing: false,
        status: PaymentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onShowSuccessDialog(ShowSuccessDialog event, Emitter<PaymentState> emit) {
    print('🎉 PaymentViewModel: Showing success dialog');
    emit(state.copyWith(showSuccessDialog: true));

    // Auto-hide success dialog after 10 seconds and show call dialog
    _successTimer?.cancel();
    _successTimer = Timer(const Duration(seconds: 10), () {
      print('🔄 PaymentViewModel: Hiding success dialog, showing call dialog');
      if (!isClosed) {
        add(HideSuccessDialog());
        add(ShowCallDialog());
      }
    });
  }

  void _onHideSuccessDialog(HideSuccessDialog event, Emitter<PaymentState> emit) {
    print('🔇 PaymentViewModel: Hiding success dialog');
    emit(state.copyWith(showSuccessDialog: false));
  }

  void _onShowCallDialog(ShowCallDialog event, Emitter<PaymentState> emit) {
    print('📞 PaymentViewModel: Showing call dialog');
    emit(state.copyWith(showCallDialog: true));

    // Auto-hide call dialog after 10 seconds
    _callTimer?.cancel();
    _callTimer = Timer(const Duration(seconds: 10), () {
      print('🔇 PaymentViewModel: Auto-hiding call dialog');
      if (!isClosed) {
        add(HideCallDialog());
      }
    });
  }

  void _onHideCallDialog(HideCallDialog event, Emitter<PaymentState> emit) {
    print('🔇 PaymentViewModel: Hiding call dialog');
    emit(state.copyWith(showCallDialog: false));
  }

  void _onClosePayment(ClosePayment event, Emitter<PaymentState> emit) {
    _successTimer?.cancel();
    _callTimer?.cancel();
    emit(const PaymentState());
  }

  void _onResetPayment(ResetPayment event, Emitter<PaymentState> emit) {
    _successTimer?.cancel();
    _callTimer?.cancel();
    emit(state.copyWith(
      status: PaymentStatus.initial,
      errorMessage: null,
      isProcessing: false,
      showSuccessDialog: false,
      showCallDialog: false,
    ));
  }

  @override
  Future<void> close() {
    _successTimer?.cancel();
    _callTimer?.cancel();
    return super.close();
  }
} 
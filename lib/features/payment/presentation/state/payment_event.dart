import 'package:equatable/equatable.dart';
import 'payment_state.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentData extends PaymentEvent {
  final List<CartItem> cartItems;
  final double totalAmount;

  const LoadPaymentData({
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [cartItems, totalAmount];
}

class SelectPaymentMethod extends PaymentEvent {
  final PaymentMethodType paymentMethod;

  const SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class SelectOnlineService extends PaymentEvent {
  final OnlineService onlineService;

  const SelectOnlineService(this.onlineService);

  @override
  List<Object?> get props => [onlineService];
}

class ProcessPayment extends PaymentEvent {
  final String deliveryInstructions;

  const ProcessPayment({this.deliveryInstructions = ''});

  @override
  List<Object?> get props => [deliveryInstructions];
}

class ShowSuccessDialog extends PaymentEvent {
  final String orderId;

  const ShowSuccessDialog(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class HideSuccessDialog extends PaymentEvent {}

class ShowCallDialog extends PaymentEvent {}

class HideCallDialog extends PaymentEvent {}

class ClosePayment extends PaymentEvent {}

class ResetPayment extends PaymentEvent {} 
import 'package:equatable/equatable.dart';

enum PaymentMethodType { online, cod }
enum OnlineService { esewa, khalti }
enum PaymentStatus { initial, processing, success, error }

class PaymentState extends Equatable {
  final PaymentMethodType selectedPaymentMethod;
  final OnlineService selectedOnlineService;
  final PaymentStatus status;
  final String? errorMessage;
  final bool isProcessing;
  final bool showSuccessDialog;
  final bool showCallDialog;
  final String orderId;
  final double totalAmount;
  final int totalItems;
  final List<CartItem> cartItems;

  const PaymentState({
    this.selectedPaymentMethod = PaymentMethodType.online,
    this.selectedOnlineService = OnlineService.esewa,
    this.status = PaymentStatus.initial,
    this.errorMessage,
    this.isProcessing = false,
    this.showSuccessDialog = false,
    this.showCallDialog = false,
    this.orderId = '',
    this.totalAmount = 0.0,
    this.totalItems = 0,
    this.cartItems = const [],
  });

  PaymentState copyWith({
    PaymentMethodType? selectedPaymentMethod,
    OnlineService? selectedOnlineService,
    PaymentStatus? status,
    String? errorMessage,
    bool? isProcessing,
    bool? showSuccessDialog,
    bool? showCallDialog,
    String? orderId,
    double? totalAmount,
    int? totalItems,
    List<CartItem>? cartItems,
  }) {
    return PaymentState(
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedOnlineService: selectedOnlineService ?? this.selectedOnlineService,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      showCallDialog: showCallDialog ?? this.showCallDialog,
      orderId: orderId ?? this.orderId,
      totalAmount: totalAmount ?? this.totalAmount,
      totalItems: totalItems ?? this.totalItems,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  @override
  List<Object?> get props => [
        selectedPaymentMethod,
        selectedOnlineService,
        status,
        errorMessage,
        isProcessing,
        showSuccessDialog,
        showCallDialog,
        orderId,
        totalAmount,
        totalItems,
        cartItems,
      ];
}

class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? image;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.image,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      image: json['image'],
    );
  }
} 
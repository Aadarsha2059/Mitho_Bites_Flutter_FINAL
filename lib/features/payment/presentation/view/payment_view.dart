import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import '../state/payment_event.dart';
import '../state/payment_state.dart';
import '../view_model/payment_view_model.dart';

class PaymentView extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final VoidCallback? onClose;
  final VoidCallback? onContinueShopping;

  const PaymentView({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
    this.onClose,
    this.onContinueShopping,
  }) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final TextEditingController _deliveryInstructionsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _deliveryInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<PaymentViewModel>(),
      child: Builder(
        builder: (context) {
          // Initialize payment data when the widget is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<PaymentViewModel>().add(
              LoadPaymentData(
                cartItems: widget.cartItems,
                totalAmount: widget.totalAmount,
              ),
            );
          });

          return Scaffold(
            body: BlocConsumer<PaymentViewModel, PaymentState>(
              listener: (context, state) {
                print(
                  '🎯 PaymentView: State changed - Status: ${state.status}, isProcessing: ${state.isProcessing}',
                );
                if (state.status == PaymentStatus.success) {
                  print(
                    '🎉 PaymentView: Success status detected, NOT calling onOrderSuccess yet',
                  );
                  // Don't call onOrderSuccess immediately - let dialogs show first
                }
                if (state.errorMessage != null) {
                  print('❌ PaymentView: Error detected: ${state.errorMessage}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                print('🎯 PaymentView: Building with status: ${state.status}');
                if (state.status == PaymentStatus.success) {
                  print('🎉 PaymentView: Building success view');
                  return _buildSuccessView(context, state);
                }

                print('🎯 PaymentView: Building payment view');
                return _buildPaymentView(context, state);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentView(BuildContext context, PaymentState state) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEABB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8B500),
        foregroundColor: Colors.white,
        title: const Text(
          'Payment Methods',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            context.read<PaymentViewModel>().add(ClosePayment());
            widget.onClose?.call();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentForm(context, state),
            const SizedBox(height: 20),
            _buildOrderSummary(state),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm(BuildContext context, PaymentState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA18CD1).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Secure your Mitho Bites order now',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFA18CD1),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildPaymentMethodSelection(context, state),
          const SizedBox(height: 20),
          if (state.selectedPaymentMethod == PaymentMethodType.online)
            _buildOnlineServiceSelection(context, state),
          const SizedBox(height: 20),
          _buildDeliveryInstructions(),
          const SizedBox(height: 24),
          _buildProcessButton(context, state),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection(
    BuildContext context,
    PaymentState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2346),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodButton(
                context: context,
                icon: Icons.phone_android,
                label: 'Online',
                isSelected:
                    state.selectedPaymentMethod == PaymentMethodType.online,
                onTap:
                    () => context.read<PaymentViewModel>().add(
                      const SelectPaymentMethod(PaymentMethodType.online),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPaymentMethodButton(
                context: context,
                icon: Icons.money,
                label: 'Cash on Delivery',
                isSelected:
                    state.selectedPaymentMethod == PaymentMethodType.cod,
                onTap:
                    () => context.read<PaymentViewModel>().add(
                      const SelectPaymentMethod(PaymentMethodType.cod),
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFFF8B500) : const Color(0xFFE9ECEF),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected
                  ? const Color(0xFFF8B500).withOpacity(0.1)
                  : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFFF8B500)
                      : const Color(0xFF6C757D),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isSelected
                        ? const Color(0xFFF8B500)
                        : const Color(0xFF6C757D),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineServiceSelection(
    BuildContext context,
    PaymentState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Online Service',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2346),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9ECEF)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<OnlineService>(
              value: state.selectedOnlineService,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items:
                  OnlineService.values.map((service) {
                    return DropdownMenuItem<OnlineService>(
                      value: service,
                      child: Row(
                        children: [
                          Icon(
                            service == OnlineService.esewa
                                ? Icons.account_balance
                                : Icons.payment,
                            color: const Color(0xFFF8B500),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            service.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<PaymentViewModel>().add(
                    SelectOnlineService(value),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Accepted only **',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFE91E63),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Instructions (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2346),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _deliveryInstructionsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter any special delivery instructions...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFF8B500), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessButton(BuildContext context, PaymentState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            state.isProcessing
                ? null
                : () {
                  _showConfirmationDialog(context);
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8B500),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          disabledBackgroundColor: Colors.grey,
        ),
        child:
            state.isProcessing
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  'Place My Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2346),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to place this order?',
                style: TextStyle(fontSize: 16, color: Color(0xFF2D2346)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<PaymentViewModel>().add(
                  ProcessPayment(
                    deliveryInstructions: _deliveryInstructionsController.text,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Yes, Place Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderSummary(PaymentState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA18CD1).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2346),
            ),
          ),
          const SizedBox(height: 16),
          ...state.cartItems.map(
            (item) => _buildSummaryRow(
              item.productName,
              '${item.quantity}x NPR ${item.price.toStringAsFixed(2)}',
            ),
          ),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total',
            'NPR ${state.totalAmount.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Payment',
            state.selectedPaymentMethod == PaymentMethodType.online
                ? state.selectedOnlineService.name.toUpperCase()
                : 'Cash',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isTotal ? const Color(0xFFE53935) : const Color(0xFF2D2346),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isTotal ? const Color(0xFFE53935) : const Color(0xFF2D2346),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, PaymentState state) {
    // Add a small delay to ensure the success view is properly rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && state.showSuccessDialog) {
          print(
            '🎉 PaymentView: Success view rendered, dialogs should be visible',
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFCEABB),
      body: Stack(
        children: [
          SafeArea(
            child: _OrderConfirmationScreen(
              orderId: state.orderId,
              totalAmount: state.totalAmount,
              cartItems: state.cartItems,
              onContinueShopping:
                  widget.onContinueShopping ??
                  () {
                    // Default action if callback is not provided
                    Navigator.pop(context);
                  },
            ),
          ),
          // Show success dialog if flag is true
          if (state.showSuccessDialog) _buildSuccessDialog(),
          // Show call dialog if flag is true
          if (state.showCallDialog) _buildCallDialog(),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with cross icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green[700],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Order Placed Successfully! 🎉',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<PaymentViewModel>().add(
                          HideSuccessDialog(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Bhok lageko cha?? Don\'t worry we will deliver foods for you. 🍕',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Your order is being prepared with love! ❤️',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallDialog() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with cross icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.phone,
                        color: Colors.orange[700],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Delivery Update 📞',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<PaymentViewModel>().add(HideCallDialog());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.green[700],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'We will contact you when we reach near to you. Visit order history section for updates! 📱',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Your food is on the way! 🚚',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderConfirmationScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final List<CartItem> cartItems;
  final VoidCallback onContinueShopping;

  const _OrderConfirmationScreen({
    required this.orderId,
    required this.totalAmount,
    required this.cartItems,
    required this.onContinueShopping,
  });

  @override
  State<_OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<_OrderConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCEABB), Color(0xFFFFF8E1), Color(0xFFFFF3E0)],
            ),
          ),
        ),

        // Confetti effect
        _buildConfetti(),

        // Main content
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Success Icon with Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, size: 60, color: Colors.green),
                ),
              ),

              const SizedBox(height: 30),

              // Success Message
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Text(
                      '🎉 BOOM! 🎉',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Order Placed Successfully!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2346),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your delicious food is on its way!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Order Details Card
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Order ID
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  color: Colors.orange[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Order ID',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.orderId,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: Colors.orange[800],
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Order Summary
                      _buildSuccessOrderSummary(),

                      const SizedBox(height: 20),

                      // Delivery Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delivery_dining,
                              color: Colors.green[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estimated Delivery',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '25-35 minutes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Continue Shopping Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        widget.onContinueShopping ??
                        () {
                          // Default action if callback is not provided
                          Navigator.pop(context);
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Colors.orange.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Continue Shopping',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.receipt, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.cartItems.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity}x ${item.productName}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '₹${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfetti() {
    return Positioned.fill(child: CustomPaint(painter: ConfettiPainter()));
  }
}

class ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.orange.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent confetti

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 2;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Add some different colored confetti
    final colors = [Colors.green, Colors.blue, Colors.purple, Colors.pink];
    for (int i = 0; i < 30; i++) {
      final color = colors[random.nextInt(colors.length)];
      final paint2 =
          Paint()
            ..color = color.withOpacity(0.4)
            ..style = PaintingStyle.fill;

      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;

      canvas.drawCircle(Offset(x, y), radius, paint2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

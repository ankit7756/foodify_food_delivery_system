import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/cart_view_model.dart';
import '../../../orders/presentation/view_model/orders_view_model.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../notifications/presentation/view_model/notification_view_model.dart';
import '../../../payment/presentation/pages/khalti_payment_page.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _addressController = TextEditingController(
    text: 'Patan, Bagmati Province, Nepal',
  );
  final _phoneController = TextEditingController(text: '9800000001');
  String _paymentMethod = 'Cash on Delivery';

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _createOrderAndFinish() async {
    final cartState = ref.read(cartViewModelProvider);

    final orderData = {
      'restaurantId': cartState.restaurantId,
      'restaurantName': cartState.restaurantName,
      'items': cartState.items
          .map(
            (item) => {
              'foodId': item.foodId,
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'image': item.image,
            },
          )
          .toList(),
      'subtotal': cartState.subtotal,
      'deliveryFee': cartState.deliveryFee,
      'totalAmount': cartState.grandTotal,
      'deliveryAddress': _addressController.text.trim(),
      'phone': _phoneController.text.trim(),
      'paymentMethod': _paymentMethod,
    };

    final success = await ref
        .read(ordersViewModelProvider.notifier)
        .createOrder(orderData);

    if (success) {
      await ref
          .read(notificationViewModelProvider.notifier)
          .addNotification(
            title: '📋 Order Placed Successfully!',
            message:
                'Your order from ${cartState.restaurantName} has been placed and is being confirmed by the restaurant.',
            type: NotificationType.order,
          );

      ref.read(cartViewModelProvider.notifier).clearCart();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Order Placed!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your order has been placed successfully!'),
                const SizedBox(height: 12),
                Text(
                  'Total: Rs. ${cartState.grandTotal.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Delivery to: ${_addressController.text}'),
                if (_paymentMethod == 'Khalti') ...[
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Payment via Khalti successful',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pop();
                  dashboardKey.currentState?.switchToTab(2);
                },
                child: const Text('View Orders'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        final errorMessage = ref.read(ordersViewModelProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? 'Failed to place order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _placeOrder() async {
    if (_addressController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Khalti payment flow
    if (_paymentMethod == 'Khalti') {
      final cartState = ref.read(cartViewModelProvider);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KhaltiPaymentPage(
            amount: cartState.grandTotal,
            restaurantName: cartState.restaurantName ?? 'Restaurant',
            onPaymentSuccess: () async {
              // ✅ Close Khalti page first
              if (mounted) Navigator.pop(context);
              // ✅ Then create order directly, no extra loading dialog
              await _createOrderAndFinish();
            },
          ),
        ),
      );
      return;
    }

    // Cash on Delivery or eSewa — direct
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await _createOrderAndFinish();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter delivery address',
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Color(0xFFFF6B35),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFFFF6B35)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _buildPaymentOption('Cash on Delivery', Icons.money),
            _buildPaymentOption('eSewa', Icons.account_balance_wallet),
            _buildPaymentOption('Khalti', Icons.payment),

            if (_paymentMethod == 'Khalti') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF5C2D91).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF5C2D91).withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF5C2D91),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You will be redirected to Khalti payment screen to complete your payment.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5C2D91),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Items', '${cartState.items.length}'),
                  _buildSummaryRow('Total Quantity', '${cartState.itemCount}'),
                  _buildSummaryRow(
                    'Subtotal',
                    'Rs. ${cartState.subtotal.toStringAsFixed(0)}',
                  ),
                  _buildSummaryRow(
                    'Delivery Fee',
                    'Rs. ${cartState.deliveryFee.toStringAsFixed(0)}',
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Grand Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Rs. ${cartState.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: _paymentMethod == 'Khalti'
                    ? const Color(0xFF5C2D91)
                    : const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                _paymentMethod == 'Khalti' ? 'Pay with Khalti' : 'Place Order',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    final isSelected = _paymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (_paymentMethod == 'Khalti'
                      ? const Color(0xFF5C2D91)
                      : const Color(0xFFFF6B35))
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (_paymentMethod == 'Khalti'
                        ? const Color(0xFF5C2D91)
                        : const Color(0xFFFF6B35))
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? (_paymentMethod == 'Khalti'
                            ? const Color(0xFF5C2D91)
                            : const Color(0xFFFF6B35))
                      : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: _paymentMethod == 'Khalti'
                    ? const Color(0xFF5C2D91)
                    : const Color(0xFFFF6B35),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

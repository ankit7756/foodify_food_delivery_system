import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodify_food_delivery_system/features/orders/data/local/review_local_storage.dart';
import 'package:foodify_food_delivery_system/features/orders/presentation/pages/review_page.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/orders_providers.dart';
import '../view_model/orders_view_model.dart';
import '../../../../core/storage/user_session_service.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../notifications/presentation/view_model/notification_view_model.dart';
import '../../../../core/sensors/proximity_service.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  OrderEntity? order;
  bool isLoading = true;
  String? errorMessage;
  bool isUpdating = false;
  final ProximityService _proximityService = ProximityService();

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
    _proximityService.startListening(); // ✅ ADD
  }

  @override
  void dispose() {
    _proximityService.dispose(); // ✅ ADD
    super.dispose();
  }

  Future<void> _loadOrderDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final token = UserSessionService.getToken();
    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'No token found';
      });
      return;
    }

    final getOrderDetailUseCase = ref.read(getOrderDetailUseCaseProvider);
    final result = await getOrderDetailUseCase(token, widget.orderId);

    result.fold(
      (failure) => setState(() {
        isLoading = false;
        errorMessage = failure.message;
      }),
      (loadedOrder) => setState(() {
        isLoading = false;
        order = loadedOrder;
      }),
    );
  }

  // ✅ Mark as delivered
  Future<void> _markAsDelivered() async {
    setState(() => isUpdating = true);

    final token = UserSessionService.getToken();
    if (token == null) return;

    final useCase = ref.read(updateOrderStatusUseCaseProvider);
    final result = await useCase(token, widget.orderId, 'delivered');

    result.fold(
      (failure) {
        setState(() => isUpdating = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${failure.message}')));
      },
      (updatedOrder) async {
        // Add notification
        await ref
            .read(notificationViewModelProvider.notifier)
            .addNotification(
              title: '✅ Order Delivered!',
              message:
                  'Your order from ${updatedOrder.restaurantName} has been delivered successfully. Enjoy your meal! 🍽️',
              type: NotificationType.order,
            );

        // Reload orders list
        await ref.read(ordersViewModelProvider.notifier).loadAllOrders();

        setState(() {
          isUpdating = false;
          order = updatedOrder;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Order marked as delivered!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Go back to orders page after short delay
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.pop(context);
        }
      },
    );
  }

  // ✅ Cancel order
  Future<void> _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
          'Are you sure you want to cancel this order? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isUpdating = true);

    final token = UserSessionService.getToken();
    if (token == null) return;

    final useCase = ref.read(updateOrderStatusUseCaseProvider);
    final result = await useCase(token, widget.orderId, 'cancelled');

    result.fold(
      (failure) {
        setState(() => isUpdating = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${failure.message}')));
      },
      (updatedOrder) async {
        // Add notification
        await ref
            .read(notificationViewModelProvider.notifier)
            .addNotification(
              title: '❌ Order Cancelled',
              message:
                  'Your order from ${updatedOrder.restaurantName} has been cancelled successfully.',
              type: NotificationType.order,
            );

        // Reload orders list
        await ref.read(ordersViewModelProvider.notifier).loadAllOrders();

        setState(() {
          isUpdating = false;
          order = updatedOrder;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order cancelled successfully'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingScaffold();
    }

    if (errorMessage != null || order == null) {
      return _buildErrorScaffold();
    }

    final isCurrentOrder = order!.isActive;
    final canCancel = order!.status == 'pending';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order #${order!.id.substring(order!.id.length - 6)}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _proximityService.isNear,
        builder: (context, isNear, _) {
          return Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStatusHeader(),
                    const SizedBox(height: 20),
                    _buildTimeline(),
                    const SizedBox(height: 20),
                    _buildRestaurantInfo(),
                    const SizedBox(height: 20),
                    _buildItemsList(),
                    const SizedBox(height: 20),
                    _buildDeliveryInfo(),
                    const SizedBox(height: 20),
                    _buildBillSummary(),
                    const SizedBox(height: 20),
                    if (order!.status == 'delivered') ...[
                      _buildReviewSection(),
                      const SizedBox(height: 20),
                    ],
                    if (isCurrentOrder) _buildActionButtons(canCancel),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Existing loading overlay
              if (isUpdating)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                  ),
                ),

              // ✅ Proximity sensor overlay
              if (isNear)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.85),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🛵', style: TextStyle(fontSize: 72)),
                      const SizedBox(height: 24),
                      const Text(
                        'Food is on the way!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Don\'t worry, we\'ve got your order 🍽️',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFF6B35).withOpacity(0.5),
                          ),
                        ),
                        child: const Text(
                          '📱 Proximity Sensor Active',
                          style: TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ✅ Action buttons at bottom
  Widget _buildActionButtons(bool canCancel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // "Have you received the order?" section
          Container(
            padding: const EdgeInsets.all(20),
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
              children: [
                const Text(
                  'Have you received your order?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // No button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isUpdating
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please wait for your delivery 🚵',
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[400]!),
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '😕  No',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Yes button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isUpdating ? null : _markAsDelivered,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '😊  Yes!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Cancel Order button (only for pending orders)
          if (canCancel) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isUpdating ? null : _cancelOrder,
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                label: const Text(
                  'Cancel Order',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(order!.status),
            _getStatusColor(order!.status).withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(order!.statusIcon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            order!.statusText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(order!.orderDate),
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            'Order Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildTimelineStep(
            'Order Placed',
            DateFormat('hh:mm a').format(order!.orderDate),
            true,
            isLast: false,
          ),
          _buildTimelineStep(
            'Preparing',
            _getTimeOrPending('preparing'),
            _isStatusCompleted('preparing'),
            isLast: false,
          ),
          _buildTimelineStep(
            'Out for Delivery',
            _getTimeOrPending('out_for_delivery'),
            _isStatusCompleted('out_for_delivery'),
            isLast: false,
          ),
          _buildTimelineStep(
            'Delivered',
            order!.deliveryDate != null
                ? DateFormat('hh:mm a').format(order!.deliveryDate!)
                : 'Pending',
            _isStatusCompleted('delivered'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Color(0xFFFF6B35),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Restaurant',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  order!.restaurantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            'Order Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...order!.items.map((item) => _buildOrderItem(item)),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            'Delivery Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.location_on_outlined,
            'Address',
            order!.deliveryAddress,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, 'Phone', order!.phone),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.payment_outlined,
            'Payment',
            order!.paymentMethod,
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
            'Bill Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildBillRow(
            'Subtotal',
            'Rs. ${order!.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _buildBillRow(
            'Delivery Fee',
            'Rs. ${order!.deliveryFee.toStringAsFixed(0)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Rs. ${order!.totalAmount.toStringAsFixed(0)}',
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
    );
  }

  // -- Reused helper widgets (same as before) --

  Widget _buildTimelineStep(
    String title,
    String time,
    bool isCompleted, {
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFFFF6B35) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? const Color(0xFFFF6B35) : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItemEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            'Rs. ${item.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFFF6B35)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
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
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(errorMessage ?? 'Order not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrderDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // Add this method to order_detail_page.dart
  Widget _buildReviewSection() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ReviewLocalStorage.getReview(widget.orderId),
      builder: (context, snapshot) {
        final review = snapshot.data;
        final hasReview = review != null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
            child: hasReview
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Stars display
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (review['rating'] as int)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '"${review['message']}"',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Text(
                        'Enjoyed your order?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Share your experience with others',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReviewPage(order: order!),
                              ),
                            );
                            setState(() {}); // Refresh to show review
                          },
                          icon: const Icon(Icons.star_outline),
                          label: const Text(
                            'Write a Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'out_for_delivery':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool _isStatusCompleted(String checkStatus) {
    const statusOrder = [
      'pending',
      'preparing',
      'out_for_delivery',
      'delivered',
    ];
    final currentIndex = statusOrder.indexOf(order!.status);
    final checkIndex = statusOrder.indexOf(checkStatus);
    return currentIndex >= checkIndex;
  }

  String _getTimeOrPending(String checkStatus) {
    if (_isStatusCompleted(checkStatus)) {
      if (checkStatus == 'preparing') {
        return DateFormat(
          'hh:mm a',
        ).format(order!.orderDate.add(const Duration(minutes: 5)));
      } else if (checkStatus == 'out_for_delivery') {
        return DateFormat(
          'hh:mm a',
        ).format(order!.orderDate.add(const Duration(minutes: 20)));
      }
    }
    return 'Pending';
  }
}

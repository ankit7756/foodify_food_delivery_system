import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/local/review_local_storage.dart';
import '../../domain/entities/order_entity.dart';
import '../pages/order_detail_page.dart';
import '../pages/review_page.dart';

class OrderCard extends StatefulWidget {
  final OrderEntity order;
  final bool isHistory;

  const OrderCard({super.key, required this.order, this.isHistory = false});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _hasReview = false;
  Map<String, dynamic>? _review;

  @override
  void initState() {
    super.initState();
    if (widget.isHistory && widget.order.status == 'delivered') {
      _loadReview();
    }
  }

  Future<void> _loadReview() async {
    final review = await ReviewLocalStorage.getReview(widget.order.id);
    if (mounted) {
      setState(() {
        _hasReview = review != null;
        _review = review;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailPage(orderId: widget.order.id),
          ),
        );
        // Refresh review status when coming back
        if (widget.isHistory && widget.order.status == 'delivered') {
          _loadReview();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order #${widget.order.id.substring(widget.order.id.length - 6)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      widget.order.status,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.order.statusIcon,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.order.statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(widget.order.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Reviewed badge
            if (_hasReview) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          'Reviewed  ${_review!['rating']}/5',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Restaurant Name
            Row(
              children: [
                const Icon(
                  Icons.restaurant,
                  size: 18,
                  color: Color(0xFFFF6B35),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.order.restaurantName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              '${widget.order.items.length} ${widget.order.items.length == 1 ? 'item' : 'items'}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 12),

            // Date & Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat(
                        'MMM dd, yyyy • hh:mm a',
                      ).format(widget.order.orderDate),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(
                  'Rs. ${widget.order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),

            // Action buttons for history delivered orders
            if (widget.isHistory && widget.order.status == 'delivered') ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reorder feature coming soon!'),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B35)),
                        foregroundColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reorder'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _hasReview
                        // Already reviewed — show static badge
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.4),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '⭐ Reviewed',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          )
                        // Not reviewed yet — show Review button
                        : ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ReviewPage(order: widget.order),
                                ),
                              );
                              _loadReview();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Review'),
                          ),
                  ),
                ],
              ),
            ],

            // Cancelled badge for cancelled orders
            if (widget.isHistory && widget.order.status == 'cancelled') ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: const Center(
                  child: Text(
                    '❌ Order Cancelled',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
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
}

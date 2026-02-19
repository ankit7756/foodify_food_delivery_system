import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/notification_entity.dart';
import '../view_model/notification_view_model.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Mark all as read when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifState = ref.watch(notificationViewModelProvider);
    final allNotifications = notifState.allNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (notifState.notifications.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All'),
                    content: const Text(
                      'Remove all notifications? Promo offers will remain.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  ref.read(notificationViewModelProvider.notifier).clearAll();
                }
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Color(0xFFFF6B35)),
              ),
            ),
        ],
      ),
      body: allNotifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allNotifications.length,
              itemBuilder: (context, index) {
                final notification = allNotifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  Widget _buildNotificationCard(NotificationEntity notification) {
    return Dismissible(
      key: Key(notification.id),
      // Only non-promo notifications can be dismissed
      direction: notification.isPromo
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
      ),
      onDismissed: (_) {
        ref
            .read(notificationViewModelProvider.notifier)
            .deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification removed'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: !notification.isRead && !notification.isPromo
              ? Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getTypeColor(notification.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getTypeEmoji(notification.type),
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: notification.isRead
                        ? FontWeight.w500
                        : FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (!notification.isPromo)
                GestureDetector(
                  onTap: () {
                    ref
                        .read(notificationViewModelProvider.notifier)
                        .deleteNotification(notification.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (notification.isPromo)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🏷️ Offer',
                        style: TextStyle(fontSize: 11, color: Colors.amber),
                      ),
                    )
                  else
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order updates and offers will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFFFF6B35);
      case NotificationType.profile:
        return Colors.blue;
      case NotificationType.promo:
        return Colors.amber;
    }
  }

  String _getTypeEmoji(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return '🛵';
      case NotificationType.profile:
        return '👤';
      case NotificationType.promo:
        return '🎁';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM dd').format(time);
  }
}

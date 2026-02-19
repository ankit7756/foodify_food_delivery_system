import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/notification_entity.dart';
import '../state/notification_state.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      NotificationViewModel.new,
    );

class NotificationViewModel extends Notifier<NotificationState> {
  static const String _storageKey = 'foodify_notifications';
  static const int _maxNotifications = 10;

  // 3 hardcoded promo notifications — always at bottom
  static final List<NotificationEntity> _promoNotifications = [
    NotificationEntity(
      id: 'promo_1',
      title: '🎉 50% Off Your Next Order!',
      message:
          'Use code FOODIFY50 and get 50% off on orders above Rs. 500. Valid this weekend only!',
      type: NotificationType.promo,
      createdAt: DateTime(2025, 1, 1),
      isRead: true,
      isPromo: true,
    ),
    NotificationEntity(
      id: 'promo_2',
      title: '🚀 Free Delivery All Week!',
      message:
          'Enjoy free delivery on all orders this week. No minimum order required. Order now!',
      type: NotificationType.promo,
      createdAt: DateTime(2025, 1, 2),
      isRead: true,
      isPromo: true,
    ),
    NotificationEntity(
      id: 'promo_3',
      title: '🍔 New Restaurants Added!',
      message:
          'We\'ve added 10+ new restaurants near you. Explore new cuisines and flavors today!',
      type: NotificationType.promo,
      createdAt: DateTime(2025, 1, 3),
      isRead: true,
      isPromo: true,
    ),
  ];

  @override
  NotificationState build() {
    // Load saved notifications from SharedPreferences
    _loadNotifications();
    return NotificationState(
      notifications: const [],
      promoNotifications: _promoNotifications,
      unreadCount: 0,
    );
  }

  // Load from SharedPreferences
  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final notifications = jsonList
            .map((json) => _fromJson(json as Map<String, dynamic>))
            .toList();
        final unread = notifications.where((n) => !n.isRead).length;
        state = state.copyWith(
          notifications: notifications,
          unreadCount: unread,
        );
      }
    } catch (_) {}
  }

  // Save to SharedPreferences
  Future<void> _saveNotifications(
    List<NotificationEntity> notifications,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = notifications.map((n) => _toJson(n)).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  // Add a new notification (called from other parts of the app)
  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) async {
    final newNotification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      isPromo: false,
    );

    var updatedList = [newNotification, ...state.notifications];

    // Cap at max 10 — remove oldest if exceeded
    if (updatedList.length > _maxNotifications) {
      updatedList = updatedList.take(_maxNotifications).toList();
    }

    final unread = updatedList.where((n) => !n.isRead).length;

    state = state.copyWith(notifications: updatedList, unreadCount: unread);

    await _saveNotifications(updatedList);
  }

  // Delete a single notification
  Future<void> deleteNotification(String id) async {
    final updatedList = state.notifications.where((n) => n.id != id).toList();
    final unread = updatedList.where((n) => !n.isRead).length;

    state = state.copyWith(notifications: updatedList, unreadCount: unread);

    await _saveNotifications(updatedList);
  }

  // Mark all as read (when user opens notification page)
  Future<void> markAllAsRead() async {
    final updatedList = state.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();

    state = state.copyWith(notifications: updatedList, unreadCount: 0);

    await _saveNotifications(updatedList);
  }

  // Clear all non-promo notifications
  Future<void> clearAll() async {
    state = state.copyWith(notifications: [], unreadCount: 0);
    await _saveNotifications([]);
  }

  // JSON helpers
  Map<String, dynamic> _toJson(NotificationEntity n) => {
    'id': n.id,
    'title': n.title,
    'message': n.message,
    'type': n.type.name,
    'createdAt': n.createdAt.toIso8601String(),
    'isRead': n.isRead,
    'isPromo': n.isPromo,
  };

  NotificationEntity _fromJson(Map<String, dynamic> json) => NotificationEntity(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    type: NotificationType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => NotificationType.order,
    ),
    createdAt: DateTime.parse(json['createdAt']),
    isRead: json['isRead'] ?? false,
    isPromo: json['isPromo'] ?? false,
  );
}

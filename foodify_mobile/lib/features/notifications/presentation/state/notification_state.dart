import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationState extends Equatable {
  final List<NotificationEntity> notifications; // real notifications (max 10)
  final List<NotificationEntity> promoNotifications; // always 3 hardcoded
  final int unreadCount;

  const NotificationState({
    this.notifications = const [],
    this.promoNotifications = const [],
    this.unreadCount = 0,
  });

  // All displayed = real (newest first) + promos at bottom
  List<NotificationEntity> get allNotifications => [
    ...notifications,
    ...promoNotifications,
  ];

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    List<NotificationEntity>? promoNotifications,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      promoNotifications: promoNotifications ?? this.promoNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [notifications, promoNotifications, unreadCount];
}

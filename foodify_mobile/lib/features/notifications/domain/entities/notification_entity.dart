import 'package:equatable/equatable.dart';

enum NotificationType { order, profile, promo }

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final bool isPromo;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.isPromo = false,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    bool? isPromo,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isPromo: isPromo ?? this.isPromo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    type,
    createdAt,
    isRead,
    isPromo,
  ];
}

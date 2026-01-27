import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String? profileImage;
  final String role;

  const UserProfileEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.role,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    username,
    email,
    phone,
    profileImage,
    role,
  ];
}

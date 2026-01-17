class AuthApiModel {
  final String message;
  final String? token;
  final String? id;
  final String? username;
  final String? email;
  final String? fullName;
  final String? phone;

  AuthApiModel({
    required this.message,
    this.token,
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.phone,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return AuthApiModel(
      message: json['message'] ?? '',
      token: json['token'],
      id: user['_id'],
      username: user['username'],
      email: user['email'],
      fullName: user['fullName'],
      phone: user['phone'],
    );
  }
}

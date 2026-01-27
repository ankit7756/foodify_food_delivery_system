class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';

  // 🆕 Profile endpoints
  static const String getProfile = '/api/auth/profile';
  static const String updateProfile = '/api/auth/profile';
}

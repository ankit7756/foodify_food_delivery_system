import 'storage_service.dart';

class UserSessionService {
  static const String tokenKey = 'auth_token';
  static const String emailKey = 'user_email';

  static Future<void> saveToken(String token) async {
    await StorageService.saveString(tokenKey, token);
  }

  static String? getToken() {
    return StorageService.getString(tokenKey);
  }

  static Future<void> saveEmail(String email) async {
    await StorageService.saveString(emailKey, email);
  }

  static String? getEmail() {
    return StorageService.getString(emailKey);
  }

  static Future<void> clearSession() async {
    await StorageService.remove(tokenKey);
    await StorageService.remove(emailKey);
  }
}

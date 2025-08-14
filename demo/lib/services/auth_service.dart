import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../models/admin_user.dart';

class AuthService {
  static const String _adminBoxName = 'admin_users';
  static const String _sessionBoxName = 'admin_session';
  static const String _defaultAdminUsername = 'admin';
  static const String _defaultAdminPassword = 'admin123';

  static Box<AdminUser> get _adminBox => Hive.box<AdminUser>(_adminBoxName);
  static Box get _sessionBox => Hive.box(_sessionBoxName);

  static Future<void> initAuthService() async {
    await Hive.openBox<AdminUser>(_adminBoxName);
    await Hive.openBox(_sessionBoxName);
    
    await _createDefaultAdminIfNotExists();
  }

  static Future<void> _createDefaultAdminIfNotExists() async {
    if (_adminBox.isEmpty) {
      final defaultAdmin = AdminUser(
        username: _defaultAdminUsername,
        passwordHash: _hashPassword(_defaultAdminPassword),
        createdAt: DateTime.now(),
      );
      await _adminBox.put(_defaultAdminUsername, defaultAdmin);
    }
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password + 'restaurant_salt_2024');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> login(String username, String password) async {
    final admin = _adminBox.get(username);
    if (admin == null || !admin.isActive) {
      return false;
    }

    final hashedPassword = _hashPassword(password);
    if (admin.passwordHash == hashedPassword) {
      await _sessionBox.put('current_admin', username);
      await _sessionBox.put('login_time', DateTime.now().millisecondsSinceEpoch);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    await _sessionBox.clear();
  }

  static bool isLoggedIn() {
    final currentAdmin = _sessionBox.get('current_admin');
    final loginTime = _sessionBox.get('login_time');
    
    if (currentAdmin == null || loginTime == null) {
      return false;
    }

    final loginDateTime = DateTime.fromMillisecondsSinceEpoch(loginTime);
    final now = DateTime.now();
    final sessionDuration = now.difference(loginDateTime);
    
    return sessionDuration.inHours < 8;
  }

  static String? getCurrentAdmin() {
    if (isLoggedIn()) {
      return _sessionBox.get('current_admin');
    }
    return null;
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    final currentAdmin = getCurrentAdmin();
    if (currentAdmin == null) return false;

    final admin = _adminBox.get(currentAdmin);
    if (admin == null) return false;

    final oldHashedPassword = _hashPassword(oldPassword);
    if (admin.passwordHash != oldHashedPassword) {
      return false;
    }

    final newAdmin = AdminUser(
      username: admin.username,
      passwordHash: _hashPassword(newPassword),
      createdAt: admin.createdAt,
      isActive: admin.isActive,
    );

    await _adminBox.put(currentAdmin, newAdmin);
    return true;
  }

  static Map<String, String> getDefaultCredentials() {
    return {
      'username': _defaultAdminUsername,
      'password': _defaultAdminPassword,
    };
  }
}
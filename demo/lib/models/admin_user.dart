import 'package:hive/hive.dart';

part 'admin_user.g.dart';

@HiveType(typeId: 4)
class AdminUser extends HiveObject {
  @HiveField(0)
  final String username;
  
  @HiveField(1)
  final String passwordHash;
  
  @HiveField(2)
  final DateTime createdAt;
  
  @HiveField(3)
  final bool isActive;

  AdminUser({
    required this.username,
    required this.passwordHash,
    required this.createdAt,
    this.isActive = true,
  });
}
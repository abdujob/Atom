import 'package:hive/hive.dart';
import 'cart.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final List<CartItem> items;
  
  @HiveField(2)
  final double totalAmount;
  
  @HiveField(3)
  final DateTime createdAt;
  
  @HiveField(4)
  final String paymentMethod;
  
  @HiveField(5)
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.paymentMethod,
    this.status = 'completed',
  });
}
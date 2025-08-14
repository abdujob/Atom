import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'menu_item.dart';
import 'order.dart';
import '../services/database_service.dart';

part 'cart.g.dart';

@HiveType(typeId: 2)
class CartItem extends HiveObject {
  @HiveField(0)
  final MenuItem menuItem;
  
  @HiveField(1)
  final List<CustomizationOption> selectedOptions;
  
  @HiveField(2)
  int quantity;

  CartItem({
    required this.menuItem,
    required this.selectedOptions,
    this.quantity = 1,
  });

  double get totalPrice {
    double optionsPrice = selectedOptions.fold(
      0,
          (sum, option) => sum + option.price,
    );
    return (menuItem.price + optionsPrice) * quantity;
  }

  get name => menuItem.name;
  get price => menuItem.price;
}

class Cart extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  /// ✅ Calcule le prix total de tous les articles
  double get totalPrice => _items.fold(
    0,
        (sum, item) => sum + item.totalPrice,
  );

  /// ✅ Ajoute un article au panier
  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  /// ✅ Supprime un article du panier
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  /// ✅ Vide complètement le panier
  void clearCart() {
    _items = [];
    notifyListeners();
  }

  /// ✅ Sauvegarde la commande dans la base de données
  Future<String> saveOrder(String paymentMethod) async {
    if (_items.isEmpty) return '';
    
    final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    final order = Order(
      id: orderId,
      items: List.from(_items),
      totalAmount: totalPrice,
      createdAt: DateTime.now(),
      paymentMethod: paymentMethod,
    );
    
    await DatabaseService.saveOrder(order);
    return orderId;
  }
}

import 'package:flutter/foundation.dart';
import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  final List<CustomizationOption> selectedOptions;
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
}

import 'package:flutter_test/flutter_test.dart';
import 'package:self_service_terminal/models/menu_item.dart';
import 'package:self_service_terminal/models/cart.dart';
import 'package:self_service_terminal/models/order.dart';

void main() {
  group('Database Model Tests', () {
    test('MenuItem should have correct properties', () {
      final menuItem = MenuItem(
        id: 'test_1',
        name: 'Test Item',
        description: 'Test description',
        price: 1000.0,
        imageUrl: 'test.png',
        category: 'Test',
      );

      expect(menuItem.id, 'test_1');
      expect(menuItem.name, 'Test Item');
      expect(menuItem.description, 'Test description');
      expect(menuItem.price, 1000.0);
      expect(menuItem.imageUrl, 'test.png');
      expect(menuItem.category, 'Test');
    });

    test('CustomizationOption should have correct properties', () {
      final option = CustomizationOption(
        name: 'Extra Cheese',
        price: 200.0,
        imageUrl: 'cheese.png',
        selected: true,
      );

      expect(option.name, 'Extra Cheese');
      expect(option.price, 200.0);
      expect(option.imageUrl, 'cheese.png');
      expect(option.selected, true);
    });

    test('CartItem should calculate total price correctly', () {
      final menuItem = MenuItem(
        id: 'test_1',
        name: 'Test Item',
        description: 'Test description',
        price: 1000.0,
        imageUrl: 'test.png',
        category: 'Test',
      );

      final option = CustomizationOption(
        name: 'Extra Cheese',
        price: 200.0,
        imageUrl: 'cheese.png',
        selected: true,
      );

      final cartItem = CartItem(
        menuItem: menuItem,
        selectedOptions: [option],
        quantity: 2,
      );

      expect(cartItem.totalPrice, 2400.0); // (1000 + 200) * 2
    });

    test('Order should have correct properties', () {
      final menuItem = MenuItem(
        id: 'test_1',
        name: 'Test Item',
        description: 'Test description',
        price: 1000.0,
        imageUrl: 'test.png',
        category: 'Test',
      );

      final cartItem = CartItem(
        menuItem: menuItem,
        selectedOptions: [],
        quantity: 1,
      );

      final now = DateTime.now();
      final order = Order(
        id: 'order_1',
        items: [cartItem],
        totalAmount: 1000.0,
        createdAt: now,
        paymentMethod: 'cash',
        status: 'completed',
      );

      expect(order.id, 'order_1');
      expect(order.items.length, 1);
      expect(order.totalAmount, 1000.0);
      expect(order.createdAt, now);
      expect(order.paymentMethod, 'cash');
      expect(order.status, 'completed');
    });

    test('Cart should manage items correctly', () {
      final cart = Cart();
      final menuItem = MenuItem(
        id: 'test_1',
        name: 'Test Item',
        description: 'Test description',
        price: 1000.0,
        imageUrl: 'test.png',
        category: 'Test',
      );

      final cartItem = CartItem(
        menuItem: menuItem,
        selectedOptions: [],
        quantity: 1,
      );

      cart.addItem(cartItem);

      expect(cart.items.length, 1);
      expect(cart.totalPrice, 1000.0);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:self_service_terminal/models/cart.dart';
import 'package:self_service_terminal/models/menu_item.dart';

void main() {
  group('Cart Tests', () {
    late Cart cart;
    late MenuItem testItem;
    late CustomizationOption testOption;

    setUp(() {
      cart = Cart();
      testItem = MenuItem(
        id: 'test_item',
        name: 'Test Item',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'test.png',
        category: 'Test',
      );
      testOption = CustomizationOption(
        name: 'Test Option',
        price: 50.0,
        imageUrl: 'option.png',
      );
    });

    test('should start with empty cart', () {
      expect(cart.items.isEmpty, true);
      expect(cart.totalPrice, 0.0);
    });

    test('should add item to cart', () {
      final cartItem = CartItem(
        menuItem: testItem,
        selectedOptions: [testOption],
        quantity: 1,
      );

      cart.addItem(cartItem);

      expect(cart.items.length, 1);
      expect(cart.items.first, cartItem);
    });

    test('should calculate total price correctly', () {
      final cartItem = CartItem(
        menuItem: testItem,
        selectedOptions: [testOption],
        quantity: 2,
      );

      cart.addItem(cartItem);

      // Total should be (item price + option price) * quantity
      // (100 + 50) * 2 = 300
      expect(cart.totalPrice, 300.0);
    });

    test('should remove item from cart', () {
      final cartItem = CartItem(
        menuItem: testItem,
        selectedOptions: [],
        quantity: 1,
      );

      cart.addItem(cartItem);
      expect(cart.items.length, 1);

      cart.removeItem(cartItem);
      expect(cart.items.isEmpty, true);
    });

    test('should clear cart', () {
      final cartItem = CartItem(
        menuItem: testItem,
        selectedOptions: [],
        quantity: 1,
      );

      cart.addItem(cartItem);
      expect(cart.items.length, 1);

      cart.clearCart();
      expect(cart.items.isEmpty, true);
    });
  });

  group('CartItem Tests', () {
    late MenuItem testItem;
    late CustomizationOption option1;
    late CustomizationOption option2;

    setUp(() {
      testItem = MenuItem(
        id: 'test_item',
        name: 'Test Item',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'test.png',
        category: 'Test',
      );
      option1 = CustomizationOption(
        name: 'Option 1',
        price: 25.0,
        imageUrl: 'option1.png',
      );
      option2 = CustomizationOption(
        name: 'Option 2',
        price: 35.0,
        imageUrl: 'option2.png',
      );
    });

    test('should calculate total price with options', () {
      final cartItem = CartItem(
        menuItem: testItem,
        selectedOptions: [option1, option2],
        quantity: 1,
      );

      // Total should be item price + sum of option prices
      // 100 + 25 + 35 = 160
      expect(cartItem.totalPrice, 160.0);
    });

    test('should calculate total price with quantity', () {
      final cartItem = CartItem(
        menuItem: testItem,
        selectedOptions: [option1],
        quantity: 3,
      );

      // Total should be (item price + option price) * quantity
      // (100 + 25) * 3 = 375
      expect(cartItem.totalPrice, 375.0);
    });
  });
}
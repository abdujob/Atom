import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:self_service_terminal/main.dart';
import 'package:self_service_terminal/models/cart.dart';
import 'package:self_service_terminal/models/menu_item.dart';
import 'package:self_service_terminal/models/admin_user.dart';
import 'package:self_service_terminal/models/order.dart';
import 'package:self_service_terminal/services/database_service.dart';
import 'package:self_service_terminal/services/auth_service.dart';
import 'package:self_service_terminal/services/data_initialization_service.dart';

void main() {
  group('Widget Tests', () {
    setUpAll(() async {
      Hive.init('.');
      
      Hive.registerAdapter(MenuItemAdapter());
      Hive.registerAdapter(CustomizationOptionAdapter());
      Hive.registerAdapter(CartItemAdapter());
      Hive.registerAdapter(OrderAdapter());
      Hive.registerAdapter(AdminUserAdapter());

      await Hive.openBox<MenuItem>('menu_items');
      await Hive.openBox<Order>('orders');
      await Hive.openBox<CustomizationOption>('customization_options');
      await Hive.openBox<AdminUser>('admin_users');
      await Hive.openBox('admin_session');

      await DataInitializationService.initializeDefaultData();
    });

    tearDownAll(() async {
      await Hive.close();
    });

    testWidgets('Restaurant app should load menu screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => Cart(),
          child: const RestaurantApp(),
        ),
      );

      // Verify that the app title is displayed
      expect(find.text("S'TACOS"), findsOneWidget);
      
      // Verify that category tabs are present
      expect(find.text('Tacos'), findsWidgets);
      expect(find.text('Burger'), findsWidgets);
      expect(find.text('Pizza'), findsWidgets);
    });

    testWidgets('Cart button should be present', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => Cart(),
          child: const RestaurantApp(),
        ),
      );

      // Verify that cart button exists
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('Menu items should be displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => Cart(),
          child: const RestaurantApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that menu items are displayed (should show Tacos items by default)
      expect(find.text('Tacos M'), findsOneWidget);
      expect(find.text('Tacos L'), findsOneWidget);
    });

    testWidgets('Should switch categories when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => Cart(),
          child: const RestaurantApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Burger category
      await tester.tap(find.text('Burger').first);
      await tester.pumpAndSettle();

      // Verify burger items are now shown
      expect(find.text('Burger Classic'), findsOneWidget);
      expect(find.text('Burger Deluxe'), findsOneWidget);
    });
  });
}

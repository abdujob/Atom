import 'package:hive_flutter/hive_flutter.dart';
import '../models/menu_item.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/admin_user.dart';
import '../models/category.dart';

class DatabaseService {
  static const String _menuItemsBox = 'menu_items';
  static const String _ordersBox = 'orders';
  static const String _customizationOptionsBox = 'customization_options';
  static const String _categoriesBox = 'categories';

  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(MenuItemAdapter());
    Hive.registerAdapter(CustomizationOptionAdapter());
    Hive.registerAdapter(CartItemAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(AdminUserAdapter());
    Hive.registerAdapter(CategoryAdapter());

    await Hive.openBox<MenuItem>(_menuItemsBox);
    await Hive.openBox<Order>(_ordersBox);
    await Hive.openBox<CustomizationOption>(_customizationOptionsBox);
    await Hive.openBox<Category>(_categoriesBox);
  }

  static Box<MenuItem> get _menuItemsBoxInstance => Hive.box<MenuItem>(_menuItemsBox);
  static Box<Order> get _ordersBoxInstance => Hive.box<Order>(_ordersBox);
  static Box<CustomizationOption> get _customizationOptionsBoxInstance => Hive.box<CustomizationOption>(_customizationOptionsBox);
  static Box<Category> get _categoriesBoxInstance => Hive.box<Category>(_categoriesBox);

  static Future<void> saveMenuItems(List<MenuItem> items) async {
    final Map<String, MenuItem> itemsMap = {
      for (MenuItem item in items) item.id: item
    };
    await _menuItemsBoxInstance.putAll(itemsMap);
  }

  static List<MenuItem> getAllMenuItems() {
    return _menuItemsBoxInstance.values.toList();
  }

  static MenuItem? getMenuItem(String id) {
    return _menuItemsBoxInstance.get(id);
  }

  static List<MenuItem> getMenuItemsByCategory(String category) {
    return _menuItemsBoxInstance.values
        .where((item) => item.category == category)
        .toList();
  }

  static Future<void> saveCustomizationOptions(List<CustomizationOption> options) async {
    final Map<String, CustomizationOption> optionsMap = {
      for (CustomizationOption option in options) option.name: option
    };
    await _customizationOptionsBoxInstance.putAll(optionsMap);
  }

  static List<CustomizationOption> getAllCustomizationOptions() {
    return _customizationOptionsBoxInstance.values.toList();
  }

  static Future<void> saveOrder(Order order) async {
    await _ordersBoxInstance.put(order.id, order);
  }

  static List<Order> getAllOrders() {
    return _ordersBoxInstance.values.toList();
  }

  static List<Order> getOrdersByDate(DateTime date) {
    return _ordersBoxInstance.values
        .where((order) => 
            order.createdAt.year == date.year &&
            order.createdAt.month == date.month &&
            order.createdAt.day == date.day)
        .toList();
  }

  static Order? getOrder(String id) {
    return _ordersBoxInstance.get(id);
  }

  static Future<void> clearAllOrders() async {
    await _ordersBoxInstance.clear();
  }

  static double getTotalSalesForDate(DateTime date) {
    final orders = getOrdersByDate(date);
    return orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  static int getTotalOrdersForDate(DateTime date) {
    return getOrdersByDate(date).length;
  }

  static Future<void> addMenuItem(MenuItem item) async {
    await _menuItemsBoxInstance.put(item.id, item);
  }

  static Future<void> updateMenuItem(MenuItem item) async {
    await _menuItemsBoxInstance.put(item.id, item);
  }

  static Future<void> deleteMenuItem(String itemId) async {
    await _menuItemsBoxInstance.delete(itemId);
  }

  static Future<void> addCustomizationOption(CustomizationOption option) async {
    await _customizationOptionsBoxInstance.put(option.name, option);
  }

  static Future<void> updateCustomizationOption(CustomizationOption option) async {
    await _customizationOptionsBoxInstance.put(option.name, option);
  }

  static Future<void> deleteCustomizationOption(String optionName) async {
    await _customizationOptionsBoxInstance.delete(optionName);
  }

  // Gestion des catégories
  static Future<void> saveCategories(List<Category> categories) async {
    final Map<String, Category> categoriesMap = {
      for (Category category in categories) category.id: category
    };
    await _categoriesBoxInstance.putAll(categoriesMap);
  }

  static List<Category> getAllCategories() {
    return _categoriesBoxInstance.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  static List<Category> getActiveCategories() {
    return _categoriesBoxInstance.values
        .where((category) => category.isActive)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  static Category? getCategory(String id) {
    return _categoriesBoxInstance.get(id);
  }

  static Future<void> addCategory(Category category) async {
    await _categoriesBoxInstance.put(category.id, category);
  }

  static Future<void> updateCategory(Category category) async {
    await _categoriesBoxInstance.put(category.id, category);
  }

  static Future<void> deleteCategory(String categoryId) async {
    await _categoriesBoxInstance.delete(categoryId);
  }

  // Méthodes de nettoyage complet de la base de données
  static Future<void> clearAllData() async {
    await _menuItemsBoxInstance.clear();
    await _ordersBoxInstance.clear();
    await _customizationOptionsBoxInstance.clear();
    await _categoriesBoxInstance.clear();
  }

  static Future<void> clearCategories() async {
    await _categoriesBoxInstance.clear();
  }

  static Future<void> clearMenuItems() async {
    await _menuItemsBoxInstance.clear();
  }

  static Future<void> clearCustomizationOptions() async {
    await _customizationOptionsBoxInstance.clear();
  }

  static Future<void> closeDatabase() async {
    await Hive.close();
  }
}
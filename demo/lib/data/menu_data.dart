import '../models/menu_item.dart';
import '../services/database_service.dart';

class MenuData {
  static List<MenuItem> getMenuItems() {
    return DatabaseService.getAllMenuItems();
  }

  static List<MenuItem> getMenuItemsByCategory(String category) {
    return DatabaseService.getMenuItemsByCategory(category);
  }

  static List<CustomizationOption> getCustomizationOptions() {
    return DatabaseService.getAllCustomizationOptions();
  }

  static List<Map<String, dynamic>> getCategories() {
    final categories = DatabaseService.getActiveCategories();
    return categories.map((category) => {
      'name': category.name,
      'icon': category.iconUrl,
    }).toList();
  }
}
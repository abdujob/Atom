import 'database_service.dart';
import 'data_initialization_service.dart';

class DatabaseMaintenanceService {
  static Future<void> resetAllData() async {
    await DataInitializationService.resetData();
  }

  static Future<void> compactDatabase() async {
    await DatabaseService.clearAllOrders();
  }

  static int getOrdersCount() {
    return DatabaseService.getAllOrders().length;
  }

  static int getMenuItemsCount() {
    return DatabaseService.getAllMenuItems().length;
  }

  static int getCustomizationOptionsCount() {
    return DatabaseService.getAllCustomizationOptions().length;
  }

  static int getCategoriesCount() {
    return DatabaseService.getAllCategories().length;
  }

  static Map<String, int> getDatabaseStats() {
    return {
      'orders': getOrdersCount(),
      'menuItems': getMenuItemsCount(),
      'customizationOptions': getCustomizationOptionsCount(),
      'categories': getCategoriesCount(),
    };
  }
}
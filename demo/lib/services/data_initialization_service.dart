import 'database_service.dart';
import '../models/category.dart';
import '../models/menu_item.dart';

class DataInitializationService {
  static Future<void> initializeDefaultData() async {
    // Pas d'initialisation automatique - tout se fait via l'admin
    // Base de données vidée une fois pour supprimer les anciennes données
  }

  static Future<void> _createDefaultCategories() async {
    final defaultCategories = [
      Category(
        id: 'cat_tacos',
        name: 'Tacos',
        iconUrl: 'assets/images/tacos.png',
        sortOrder: 1,
        isActive: true,
      ),
      Category(
        id: 'cat_burger',
        name: 'Burger',
        iconUrl: 'assets/images/burger.png',
        sortOrder: 2,
        isActive: true,
      ),
      Category(
        id: 'cat_pizza',
        name: 'Pizza',
        iconUrl: 'assets/images/pizza1.png',
        sortOrder: 3,
        isActive: true,
      ),
    ];
    
    for (final category in defaultCategories) {
      await DatabaseService.addCategory(category);
    }
  }

  static Future<void> _createDefaultMenuItems() async {
    final defaultMenuItems = [
      MenuItem(
        id: 'tacos_m',
        name: 'Tacos M',
        description: 'Tacos de taille moyenne',
        price: 2500,
        imageUrl: 'assets/images/img.png',
        category: 'Tacos',
      ),
      MenuItem(
        id: 'tacos_l',
        name: 'Tacos L',
        description: 'Tacos de taille grande',
        price: 4000,
        imageUrl: 'assets/images/img.png',
        category: 'Tacos',
      ),
      MenuItem(
        id: 'burger_classic',
        name: 'Burger Classic',
        description: 'Burger classique',
        price: 1000,
        imageUrl: 'assets/images/burger.png',
        category: 'Burger',
      ),
      MenuItem(
        id: 'burger_deluxe',
        name: 'Burger Deluxe',
        description: 'Burger de luxe',
        price: 1500,
        imageUrl: 'assets/images/img11.webp',
        category: 'Burger',
      ),
      MenuItem(
        id: 'burger_special',
        name: 'Burger Special',
        description: 'Burger spécial',
        price: 1200,
        imageUrl: 'assets/images/img12.webp',
        category: 'Burger',
      ),
      MenuItem(
        id: 'pizza_margherita',
        name: 'Pizza Margherita',
        description: 'Pizza Margherita classique',
        price: 1000,
        imageUrl: 'assets/images/pizza1.png',
        category: 'Pizza',
      ),
      MenuItem(
        id: 'pizza_pepperoni',
        name: 'Pizza Pepperoni',
        description: 'Pizza au pepperoni',
        price: 1200,
        imageUrl: 'assets/images/pizza1.png',
        category: 'Pizza',
      ),
      MenuItem(
        id: 'pizza_vegetarian',
        name: 'Pizza Végétarienne',
        description: 'Pizza aux légumes',
        price: 1100,
        imageUrl: 'assets/images/pizza1.png',
        category: 'Pizza',
      ),
    ];
    
    await DatabaseService.saveMenuItems(defaultMenuItems);
  }

  static Future<void> _createDefaultCustomizationOptions() async {
    final defaultCustomizationOptions = [
      CustomizationOption(
        name: 'Sauce Algérienne', 
        price: 0, 
        imageUrl: 'assets/images/algerienne.jpg'
      ),
      CustomizationOption(
        name: 'Sauce Mayonnaise', 
        price: 0, 
        imageUrl: 'assets/images/mayonnaise.jpg'
      ),
      CustomizationOption(
        name: 'Sauce Ketchup', 
        price: 0, 
        imageUrl: 'assets/images/ketchup.jpg'
      ),
    ];
    
    await DatabaseService.saveCustomizationOptions(defaultCustomizationOptions);
  }

  static Future<void> resetData() async {
    // Supprime uniquement les commandes, les menus sont gérés par l'admin
    await DatabaseService.clearAllOrders();
  }
}
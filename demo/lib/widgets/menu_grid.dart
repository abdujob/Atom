import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import 'menu_item_card.dart';

class MenuGrid extends StatelessWidget {
  final String category;

  const MenuGrid({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Sample menu items
    final List<MenuItem> menuItems = [
      MenuItem(
        id: '1',
        name: 'Tacos M',
        description: 'Tacos',
        price: 2500,
        imageUrl: 'assets/images/img.png',
        category: 'Tacos',

      ),

      MenuItem(
        id: '1',
        name: 'Tacos L',
        description: 'Tacos',
        price: 4000,
        imageUrl: 'assets/images/img.png',
        category: 'Tacos',

      ),
      MenuItem(
        id: '1',
        name: 'Burger',
        description: 'burger',
        price: 1000,
        imageUrl: 'assets/images/burger.png',
        category: 'Burger',
      ),
      MenuItem(
        id: '1',
        name: 'Burger',
        description: 'burger',
        price: 1000,
        imageUrl: 'assets/images/img11.webp',
        category: 'Burger',
      ),
      MenuItem(
        id: '1',
        name: 'Burger',
        description: 'burger',
        price: 1000,
        imageUrl: 'assets/images/img12.webpb',
        category: 'Burger',
      ),MenuItem(
        id: '1',
        name: 'Pizza',
        description: 'Pizza',
        price: 1000,
        imageUrl: 'assets/images/pizza1.png',
        category: 'Pizza',
      ),MenuItem(
        id: '1',
        name: 'Pizza',
        description: 'Pizza',
        price: 1000,
        imageUrl: 'assets/images/pizza1.png',
        category: 'Pizza',
      ),MenuItem(
        id: '1',
        name: 'Pizza',
        description: 'Pizza',
        price: 1000,
        imageUrl: 'assets/images/pizza1.png',
        category: 'Pizza',
      ),
      // Add more menu items here
    ];

    final filteredItems = menuItems.where((item) => item.category == category).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return MenuItemCard(menuItem: filteredItems[index]);
      },
    );
  }
}
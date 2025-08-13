import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../widgets/menu_grid.dart';
import '../widgets/cart_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Tacos';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tacos', 'icon': 'assets/images/tacos.png'},
    {'name': 'Burger', 'icon': 'assets/images/burger.png'},
    {'name': 'Pizza', 'icon': 'assets/images/pizza1.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "S'TACOS",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),


        ),

      ),
      body: Row(
        children: [
          // Left sidebar with categories
          Container(
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category['name'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _selectedCategory == category['name']
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: _selectedCategory == category['name']
                                    ? Colors.orange
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                category['icon'],
                                width: 75,
                                height: 75,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category['name'],
                                style: TextStyle(
                                  color: _selectedCategory == category['name']
                                      ? Colors.orange
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const CartButton(),
                ),
              ],
            ),
          ),

          // Right side with menu items
          Expanded(
            child: MenuGrid(category: _selectedCategory),
          ),
        ],
      ),

    );
  }
}
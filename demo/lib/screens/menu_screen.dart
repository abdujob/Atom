import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../data/menu_data.dart';
import '../widgets/menu_grid.dart';
import '../widgets/cart_button.dart';
import '../services/auth_service.dart';
import 'admin_login_screen.dart';
import 'admin_dashboard_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? _selectedCategory;
  int _adminTapCount = 0;
  DateTime? _lastTap;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void didUpdateWidget(MenuScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = MenuData.getCategories();
      if (_categories.isNotEmpty && _selectedCategory == null) {
        _selectedCategory = _categories.first['name'] as String;
      } else if (_categories.isNotEmpty && 
                 _selectedCategory != null && 
                 !_categories.any((cat) => cat['name'] == _selectedCategory)) {
        // Si la catégorie sélectionnée n'existe plus, sélectionner la première
        _selectedCategory = _categories.first['name'] as String;
      }
    });
  }

  void _onLogoTap() {
    final now = DateTime.now();
    if (_lastTap != null && now.difference(_lastTap!).inSeconds > 2) {
      _adminTapCount = 0;
    }
    _lastTap = now;
    _adminTapCount++;

    if (_adminTapCount >= 5) {
      _adminTapCount = 0;
      _navigateToAdmin();
    }
  }

  void _navigateToAdmin() {
    if (AuthService.isLoggedIn()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      ).then((_) => _loadCategories()); // Recharger après retour de l'admin
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
      ).then((_) => _loadCategories()); // Recharger après retour de l'admin
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: _onLogoTap,
          child: const Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ),

      ),
      body: Row(
        children: [
          // Left sidebar with categories
          Container(
            width: AppConstants.categorySidebarWidth,
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
                  child: _categories.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucune catégorie\ndisponible',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.builder(
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
            child: _selectedCategory != null
                ? MenuGrid(category: _selectedCategory!)
                : const Center(
                    child: Text(
                      'Aucune catégorie disponible.\nVeuillez contacter l\'administrateur.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),

    );
  }
}
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../data/menu_data.dart';
import '../widgets/menu_grid.dart';
import '../widgets/cart_button.dart';
import '../widgets/inactivity_detector.dart';
import '../widgets/smart_image.dart';
import '../services/auth_service.dart';
import '../services/data_initialization_service.dart';
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
    _syncWithServer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _syncWithServer() async {
    try {
      await DataInitializationService.initializeDefaultData();
      if (mounted) _loadCategories();
    } catch (e) {
      debugPrint("Erreur sync : $e");
    }
  }

  void _loadCategories() {
    setState(() {
      _categories = MenuData.getCategories();
      if (_categories.isNotEmpty && _selectedCategory == null) {
        _selectedCategory = _categories.first['name'] as String;
      } else if (_categories.isNotEmpty &&
          _selectedCategory != null &&
          !_categories.any((c) => c['name'] == _selectedCategory)) {
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
      Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdminDashboardScreen()))
          .then((_) => _loadCategories());
    } else {
      Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdminLoginScreen()))
          .then((_) => _loadCategories());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InactivityDetector(
      child: Scaffold(
        backgroundColor: AppConstants.bgDark,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  Expanded(
                    child: _selectedCategory != null
                        ? MenuGrid(
                            category: _selectedCategory!,
                          )
                        : const Center(
                            child: Text(
                              'Aucune catégorie disponible.',
                              style: TextStyle(color: AppConstants.textGrey),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppConstants.bgSidebar,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo — 5 taps = admin
          GestureDetector(
            onTap: _onLogoTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.primaryRed,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryRed.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "S'TACOS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          const Spacer(),
          const CartButton(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: AppConstants.categorySidebarWidth,
      color: AppConstants.bgSidebar,
      child: Column(
        children: [
          // Titre sidebar
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: Text(
              "MENU",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppConstants.textMuted,
                letterSpacing: 3,
              ),
            ),
          ),

          Expanded(
            child: _categories.isEmpty
                ? const Center(
                    child: Text('Aucune\ncatégorie',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppConstants.textMuted, fontSize: 12)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: _categories.length,
                    itemBuilder: (_, i) {
                      final cat = _categories[i];
                      final isSelected = _selectedCategory == cat['name'];
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedCategory = cat['name'];
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppConstants.primaryRed.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(
                                    color: AppConstants.primaryRed.withOpacity(0.5),
                                    width: 1)
                                : null,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: SmartImage(
                                  cat['icon'] ?? '',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? AppConstants.primaryRed
                                      : AppConstants.textGrey,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 20,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryRed,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

void debugPrint(String msg) {
  // ignore: avoid_print
  print('[MenuScreen] $msg');
}
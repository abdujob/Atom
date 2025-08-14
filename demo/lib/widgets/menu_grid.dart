import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/database_service.dart';
import 'menu_item_card.dart';

class MenuGrid extends StatefulWidget {
  final String category;

  const MenuGrid({super.key, required this.category});

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // Ne pas garder l'état pour forcer le rafraîchissement

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final menuItems = DatabaseService.getAllMenuItems();
    final filteredItems = menuItems.where((item) => item.category == widget.category).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun article dans la catégorie\n"${widget.category}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des articles depuis l\'interface admin',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppConstants.gridCrossAxisCount,
        childAspectRatio: AppConstants.gridChildAspectRatio,
        crossAxisSpacing: AppConstants.gridSpacing,
        mainAxisSpacing: AppConstants.gridSpacing,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return MenuItemCard(menuItem: filteredItems[index]);
      },
    );
  }
}
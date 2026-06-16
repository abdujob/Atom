import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/database_service.dart';
import 'menu_item_card.dart';

class MenuGrid extends StatefulWidget {
  final String category;
  final String searchQuery;

  const MenuGrid({
    super.key,
    required this.category,
    this.searchQuery = '',
  });

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  @override
  Widget build(BuildContext context) {
    var allItems = DatabaseService.getAllMenuItems()
        .where((item) => item.category == widget.category)
        .toList();

    // Filtrage par recherche
    if (widget.searchQuery.isNotEmpty) {
      final q = widget.searchQuery.toLowerCase();
      allItems = allItems
          .where((item) => item.name.toLowerCase().contains(q) ||
              item.description.toLowerCase().contains(q))
          .toList();
    }

    if (allItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              widget.searchQuery.isNotEmpty
                  ? 'Aucun résultat pour "${widget.searchQuery}"'
                  : 'Aucun article dans "${widget.category}"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
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
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        return MenuItemCard(menuItem: allItems[index]);
      },
    );
  }
}
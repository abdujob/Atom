import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../models/cart.dart';

class ItemDetailsScreen extends StatefulWidget {
  final MenuItem menuItem;

  const ItemDetailsScreen({super.key, required this.menuItem});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late List<CustomizationOption> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = [
      CustomizationOption(name: 'Sauce Algérienne', price: 0, imageUrl: 'assets/images/algerienne.jpg'),
      CustomizationOption(name: 'Sauce Mayonnaise', price: 0, imageUrl: 'assets/images/mayonnaise.jpg'),
      CustomizationOption(name: 'Sauce Ketchup', price: 0, imageUrl: 'assets/images/ketchup.jpg'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    widget.menuItem.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menuItem.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.menuItem.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Customizations',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: selectedOptions.map((option) {
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  Image.asset(
                                    option.imageUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10), // Espacement
                                  Text(option.name),
                                ],
                              ),
                              value: option.selected,
                              onChanged: (bool? value) {
                                setState(() {
                                  option.selected = value ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: €${_calculateTotal().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ElevatedButton(
                  onPressed: _addToCart,
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotal() {
    double optionsTotal = selectedOptions
        .where((option) => option.selected)
        .fold(0, (sum, option) => sum + option.price);
    return widget.menuItem.price + optionsTotal;
  }

  void _addToCart() {
    final cart = Provider.of<Cart>(context, listen: false);
    cart.addItem(
      CartItem(
        menuItem: widget.menuItem,
        selectedOptions: selectedOptions.where((option) => option.selected).toList(),
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

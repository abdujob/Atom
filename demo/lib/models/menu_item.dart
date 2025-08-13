class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class CustomizationOption {
  final String name;
  final double price;
  bool selected;
  final String imageUrl;

  CustomizationOption({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.selected = false,
  });
}
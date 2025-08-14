import 'package:hive/hive.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 0)
class MenuItem extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final String imageUrl;
  
  @HiveField(5)
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

@HiveType(typeId: 1)
class CustomizationOption extends HiveObject {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final double price;
  
  @HiveField(2)
  bool selected;
  
  @HiveField(3)
  final String imageUrl;

  CustomizationOption({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.selected = false,
  });
}
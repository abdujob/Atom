import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 5)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String iconUrl;

  @HiveField(3)
  int sortOrder;

  @HiveField(4)
  bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.sortOrder = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, iconUrl: $iconUrl, sortOrder: $sortOrder, isActive: $isActive}';
  }
}
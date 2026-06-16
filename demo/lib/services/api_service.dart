import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';
import '../models/category.dart';
import '../models/cart.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // ─── CATÉGORIES ───────────────────────────────────────────
  static Future<List<Category>> getCategories() async {
    final response = await http
        .get(Uri.parse('$baseUrl/categories'))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Category(
            id: 'cat_${item['name'].toString().toLowerCase().replaceAll(' ', '_')}',
            name: item['name'],
            iconUrl: item['icon'] ?? 'assets/images/placeholder.png',
            sortOrder: item['id'] as int,
            isActive: true,
          )).toList();
    }
    throw Exception('Failed to load categories');
  }

  // ─── PRODUITS ─────────────────────────────────────────────
  static Future<List<MenuItem>> getProducts() async {
    final response = await http
        .get(Uri.parse('$baseUrl/products'))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .where((item) => item['is_available'] != false) // Filtrer non disponibles
          .map((item) {
        String categoryName = 'Inconnu';
        if (item['category'] != null) {
          categoryName = item['category']['name'];
        }
        String imageUrl = 'assets/images/placeholder.png';
        if (item['image_url'] != null) {
          final raw = item['image_url'].toString();
          imageUrl = raw.startsWith('http') ? raw : 'http://127.0.0.1:8000$raw';
        }
        return MenuItem(
          id: item['id'].toString(),
          name: item['name'],
          description: item['description'] ?? '',
          price: double.parse(item['price'].toString()),
          imageUrl: imageUrl,
          category: categoryName,
        );
      }).toList();
    }
    throw Exception('Failed to load products');
  }

  // ─── COMMANDES ────────────────────────────────────────────
  /// Envoie une commande au backend Laravel.
  /// Retourne le numéro de commande généré (ex: "#0042") ou null en cas d'erreur.
  static Future<String?> sendOrder({
    required List<CartItem> items,
    required double total,
    required String paymentMethod, // 'cash' ou 'wave'
    String? waveSessionId,
  }) async {
    try {
      final itemsJson = items.map((item) => {
        'name':     item.menuItem.name,
        'quantity': item.quantity,
        'price':    item.menuItem.price,
        'total':    item.totalPrice,
        'options':  item.selectedOptions.map((o) => o.name).toList(),
      }).toList();

      final response = await http
          .post(
            Uri.parse('$baseUrl/orders'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'items':            itemsJson,
              'total':            total,
              'payment_method':   paymentMethod,
              'wave_session_id':  waveSessionId,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['order_number'] as String?;
      }
    } catch (e) {
      // En cas d'erreur réseau, on continue sans numéro de commande serveur
      debugPrint('Erreur envoi commande: $e');
    }
    return null;
  }
}

// Pour debugPrint dans le service
void debugPrint(String msg) {
  // ignore: avoid_print
  print('[ApiService] $msg');
}

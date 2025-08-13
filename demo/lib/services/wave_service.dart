import 'dart:convert';
import 'package:http/http.dart' as http;

class WaveService {
  static const String _backendUrl = 'http://192.168.1.67:5000/api/create-wave-session';
  static Future<String?> createPaymentSession(int amount) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      } else {
        print("Erreur API Wave : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception Wave : $e");
      return null;
    }
  }
}

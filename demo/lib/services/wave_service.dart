import 'dart:convert';
import 'package:http/http.dart' as http;

class WaveService {
  // URL locale et URL de secours (Render)
  static const String localUrl = "https://wavebackend-smnp.onrender.com/api";
  static const String backupUrl = "https://wavebackend-smnp.onrender.com/api";

  static Future<String?> createPaymentSession(int amount) async {
    // Essai sur le serveur local en premier
    try {
      final url = Uri.parse('$localUrl/create-wave-session?format=json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"amount": amount}),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["checkout_url"];
      }
    } catch (e) {
      print("Le serveur Wave local a échoué, essai sur le serveur de secours : $e");
    }

    // Essai sur le serveur de secours
    try {
      final url = Uri.parse('$backupUrl/create-wave-session');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"amount": amount}),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["checkout_url"];
      }
    } catch (e) {
      print("Le serveur de secours Wave a échoué : $e");
    }

    return null;
  }
}

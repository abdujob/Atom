import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'confirmation_screen.dart';

class WavePaymentScreen extends StatelessWidget {
  final String paymentUrl;
  final int amount;

  const WavePaymentScreen({super.key, required this.paymentUrl, required this.amount});

  Future<void> _launchPayment(BuildContext context) async {
    final uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Ouvre dans l'app Wave ou le navigateur
      );
      // Après le lancement, naviguer vers l'écran de confirmation
      // Vous pouvez ajuster cette logique selon la gestion des retours de paiement
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConfirmationScreen(isPaid: true)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le lien Wave")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement Wave"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Finaliser votre paiement avec Wave",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Montant à payer : ${amount.toStringAsFixed(0)} FCFA",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/images/wave.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 32),
            const Text(
              "Cliquez ci-dessous pour effectuer le paiement via l'application Wave ou votre navigateur.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _launchPayment(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Payer avec Wave"),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Revenir à l'écran précédent
              },
              child: const Text("Annuler"),
            ),
          ],
        ),
      ),
    );
  }
}
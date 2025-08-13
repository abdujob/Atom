import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_service_terminal/screens/wave_webview_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cart.dart';
import '../services/wave_service.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  void _launchWavePayment(BuildContext context) async {
    const url = 'https://wave.com/pay'; // Remplace par ton lien réel
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d'ouvrir le lien Wave")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Paiement & Panier"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text(
              "S’TACOS",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),
            // Affichage du panier fusionné
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text("Votre panier est vide."))
                  : ListView.separated(
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return ListTile(
                    title: Text(item.menuItem.name),
                    subtitle: Text(
                      "Options: ${item.selectedOptions.map((e) => e.name).join(', ')}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            cart.removeItem(item);
                          },
                        ),
                        Text("x${item.quantity}"),
                        const SizedBox(width: 8),
                        Text("${item.totalPrice.toStringAsFixed(0)} FCFA"),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 1.2, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TOTAL :",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${cart.totalPrice.toStringAsFixed(0)} FCFA",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Paiement en espèce
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConfirmationScreen(isPaid: false),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/img_1.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 8),
                      const Text("EN ESPECE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                // Paiement via Wave
                GestureDetector(
                  onTap: () async {
                    final cart = Provider.of<Cart>(context, listen: false);
                    final amount = cart.totalPrice.toInt();

                    final checkoutUrl = await WaveService.createPaymentSession(amount);

                    if (checkoutUrl != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WaveWebViewPage(paymentUrl: checkoutUrl),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erreur lors de la création de paiement Wave")),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/images/wave.png', width: 100, height: 100),
                      const SizedBox(height: 8),
                      const Text("WAVE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

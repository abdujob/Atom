import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/cart.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});


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
              AppConstants.appName,
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
                        Text("${item.totalPrice.toStringAsFixed(0)} ${AppConstants.currency}"),
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
                  "${cart.totalPrice.toStringAsFixed(0)} ${AppConstants.currency}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/cart.dart';
import '../widgets/smart_image.dart';
import 'confirmation_screen.dart';
import '../services/wave_service.dart';
import '../widgets/WaveQrPage.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundWhite,
      appBar: AppBar(
        title: const Text("Mon Panier"),
        backgroundColor: AppConstants.surfaceWhite,
        foregroundColor: AppConstants.textDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Liste des articles ─────────────────────────────
          Expanded(
            child: cart.items.isEmpty
                ? _buildEmptyCart(context)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, cart, cart.items[index]);
                    },
                  ),
          ),

          // ── Récapitulatif + boutons de paiement ───────────
          if (cart.items.isNotEmpty) _buildPaymentPanel(context, cart),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            "Votre panier est vide",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppConstants.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ajoutez des articles depuis le menu",
            style: TextStyle(color: AppConstants.textLight),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Retour au menu"),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Cart cart, CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 70,
              height: 70,
              child: SmartImage(item.menuItem.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),

          // Nom + options
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (item.selectedOptions.isNotEmpty)
                  Text(
                    item.selectedOptions.map((o) => o.name).join(', '),
                    style: const TextStyle(
                        fontSize: 12, color: AppConstants.textGrey),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${item.totalPrice.toInt()} ${AppConstants.currency}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.primaryOrange,
                  ),
                ),
              ],
            ),
          ),

          // Contrôles quantité
          Row(
            children: [
              _qtyButton(
                icon: Icons.remove,
                onTap: () => cart.removeItem(item),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              _qtyButton(
                icon: Icons.add,
                onTap: () => cart.addItem(CartItem(
                  menuItem: item.menuItem,
                  selectedOptions: item.selectedOptions,
                )),
                filled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: filled ? AppConstants.primaryOrange : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : AppConstants.textDark,
        ),
      ),
    );
  }

  Widget _buildPaymentPanel(BuildContext context, Cart cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: AppConstants.surfaceWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total à payer",
                  style: TextStyle(fontSize: 16, color: AppConstants.textGrey)),
              Text(
                "${cart.totalPrice.toInt()} ${AppConstants.currency}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppConstants.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Boutons de paiement
          Row(
            children: [
              // Espèces
              Expanded(
                child: _PaymentButton(
                  label: "EN ESPÈCES",
                  icon: Icons.payments_rounded,
                  color: AppConstants.successGreen,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ConfirmationScreen(isPaid: false, paymentMethod: 'cash'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Wave
              Expanded(
                child: _PaymentButton(
                  label: "WAVE",
                  icon: Icons.qr_code_scanner_rounded,
                  color: AppConstants.waveBlue,
                  onTap: () => _payWithWave(context, cart),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _payWithWave(BuildContext context, Cart cart) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final amount = cart.totalPrice.toInt();
    final checkoutUrl = await WaveService.createPaymentSession(amount);

    if (context.mounted) Navigator.of(context).pop();

    if (checkoutUrl != null && context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WaveQrPage(url: checkoutUrl)),
      );
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ConfirmationScreen(
              isPaid: true,
              paymentMethod: 'wave',
            ),
          ),
        );
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'initier le paiement Wave."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _PaymentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PaymentButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

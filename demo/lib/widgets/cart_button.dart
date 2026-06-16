import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/cart.dart';
import '../screens/payment_screen.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;
  int _lastCount = 0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _triggerBounce() {
    _bounceController.forward(from: 0).then((_) => _bounceController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final count = cart.items.fold<int>(0, (s, i) => s + i.quantity);

    // Animer quand un article est ajouté
    if (count != _lastCount) {
      _lastCount = count;
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerBounce());
    }

    final hasItems = count > 0;

    return GestureDetector(
      onTap: hasItems
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentScreen()),
              )
          : null,
      child: ScaleTransition(
        scale: _bounceAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: hasItems ? 20 : 16),
          decoration: BoxDecoration(
            color: hasItems ? AppConstants.primaryRed : AppConstants.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasItems
                  ? AppConstants.primaryRed
                  : Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: hasItems
                ? [
                    BoxShadow(
                      color: AppConstants.primaryRed.withOpacity(0.55),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: AppConstants.primaryRed.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône panier
              Icon(
                Icons.shopping_bag_rounded,
                color: hasItems ? Colors.white : AppConstants.textMuted,
                size: 24,
              ),

              if (hasItems) ...[
                const SizedBox(width: 10),

                // Badge nombre d'articles
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Séparateur vertical
                Container(
                  width: 1,
                  height: 22,
                  color: Colors.white.withOpacity(0.25),
                ),

                const SizedBox(width: 10),

                // Montant total en gras
                Text(
                  '${cart.totalPrice.toInt()} ${AppConstants.currency}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(width: 8),

                // Flèche
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
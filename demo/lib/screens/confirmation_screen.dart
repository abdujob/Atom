import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../constants/app_constants.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';
import 'welcome_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final bool isPaid;
  final String paymentMethod;

  const ConfirmationScreen({
    super.key,
    required this.isPaid,
    required this.paymentMethod,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with TickerProviderStateMixin {
  final BlueThermalPrinter printer = BlueThermalPrinter.instance;

  late AnimationController _checkController;
  late AnimationController _fadeController;
  late Animation<double> _checkScale;
  late Animation<double> _fadeAnim;

  String _orderNumber = '#----';
  int _countdown = 10;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _checkScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _checkController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });

    _saveAndPrint();
    _startCountdown();
  }

  Future<void> _saveAndPrint() async {
    final cart = Provider.of<Cart>(context, listen: false);

    // 1. Envoyer au backend pour avoir un numéro de commande officiel
    final serverOrderNumber = await ApiService.sendOrder(
      items: cart.items,
      total: cart.totalPrice,
      paymentMethod: widget.paymentMethod,
    );

    // 2. Numéro de commande local en fallback
    final localOrderNumber = serverOrderNumber ??
        '#${(DateTime.now().millisecondsSinceEpoch % 9000 + 1000)}';

    if (mounted) {
      setState(() => _orderNumber = localOrderNumber);
    }

    // 3. Sauvegarder localement dans Hive
    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      items: cart.items,
      totalAmount: cart.totalPrice,
      createdAt: DateTime.now(),
      paymentMethod: widget.paymentMethod,
      status: 'completed',
    );
    await DatabaseService.saveOrder(order);

    // 4. Imprimer le ticket
    await _printTicket(cart, localOrderNumber);
  }

  Future<void> _printTicket(Cart cart, String orderNumber) async {
    try {
      List<BluetoothDevice> devices = await printer.getBondedDevices();
      if (devices.isEmpty) return;

      await printer.connect(devices.first);

      printer.printNewLine();
      printer.printCustom(AppConstants.appName, 3, 1);
      printer.printCustom("-----------------------------", 1, 1);
      printer.printCustom("Commande $orderNumber", 1, 0);
      printer.printCustom(
        "${DateTime.now().day.toString().padLeft(2, '0')}/"
        "${DateTime.now().month.toString().padLeft(2, '0')}/"
        "${DateTime.now().year}  "
        "${DateTime.now().hour.toString().padLeft(2, '0')}:"
        "${DateTime.now().minute.toString().padLeft(2, '0')}",
        1,
        0,
      );
      printer.printNewLine();

      for (var item in cart.items) {
        printer.printCustom(
          "${item.menuItem.name} x${item.quantity}  ${item.totalPrice.toStringAsFixed(0)} FCFA",
          1,
          0,
        );
        for (var option in item.selectedOptions) {
          printer.printCustom("  + ${option.name}", 1, 0);
        }
      }

      printer.printCustom("-----------------------------", 1, 1);
      printer.printCustom(
          "TOTAL : ${cart.totalPrice.toStringAsFixed(0)} FCFA", 2, 1);
      printer.printNewLine();
      printer.printCustom(
        widget.isPaid ? "PAIEMENT: WAVE ✓" : "PAIEMENT: ESPECES",
        2,
        1,
      );
      printer.printNewLine();
      printer.printNewLine();
      printer.paperCut();
    } catch (e) {
      debugPrint('Erreur impression: $e');
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        _goHome();
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  void _goHome() {
    final cart = Provider.of<Cart>(context, listen: false);
    cart.clearCart();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const WelcomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      backgroundColor: AppConstants.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Zone principale de confirmation ──────────────
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icône de succès animée
                    ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: widget.isPaid
                              ? AppConstants.successGreen
                              : AppConstants.primaryOrange,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (widget.isPaid
                                      ? AppConstants.successGreen
                                      : AppConstants.primaryOrange)
                                  .withOpacity(0.35),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.isPaid
                              ? Icons.check_rounded
                              : Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          Text(
                            widget.isPaid
                                ? "Paiement confirmé !"
                                : "Commande enregistrée !",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: AppConstants.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.isPaid
                                ? "Merci pour votre paiement Wave"
                                : "Veuillez régler en caisse",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppConstants.textGrey,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Numéro de commande
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppConstants.lightOrange,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppConstants.primaryOrange
                                      .withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Votre numéro de commande",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppConstants.textGrey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _orderNumber,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: AppConstants.primaryOrange,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Récapitulatif commande ───────────────────────
            FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Récapitulatif",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.textGrey)),
                    const SizedBox(height: 8),
                    ...cart.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text("${item.menuItem.name} x${item.quantity}",
                                  style: const TextStyle(fontSize: 14)),
                              const Spacer(),
                              Text(
                                  "${item.totalPrice.toInt()} ${AppConstants.currency}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        )),
                    const Divider(height: 16),
                    Row(
                      children: [
                        const Text("TOTAL",
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        const Spacer(),
                        Text(
                            "${cart.totalPrice.toInt()} ${AppConstants.currency}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: AppConstants.primaryOrange)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Bouton retour + countdown ────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _goHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryOrange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Retour à l'accueil",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 12),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_countdown',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void debugPrint(String msg) {
  // ignore: avoid_print
  print('[Confirmation] $msg');
}

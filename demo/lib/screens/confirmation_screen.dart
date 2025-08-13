import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../models/cart.dart';

class ConfirmationScreen extends StatefulWidget {
  final bool isPaid;
  const ConfirmationScreen({super.key, required this.isPaid});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    _printTicket();
  }

  void _printTicket() async {
    final cart = Provider.of<Cart>(context, listen: false);

    List<BluetoothDevice> devices = await printer.getBondedDevices();
    if (devices.isEmpty) {
      print("Aucun périphérique Bluetooth jumelé trouvé");
      return;
    }

    // On se connecte au premier périphérique jumelé trouvé
    await printer.connect(devices.first);

    printer.printNewLine();
    printer.printCustom("S'TACOS", 3, 1);
    printer.printCustom("-----------------------------", 1, 1);
    printer.printCustom("Commande #${DateTime.now().millisecondsSinceEpoch % 100000}", 1, 0);
    printer.printNewLine();

    for (var item in cart.items) {
      printer.printCustom(
        "${item.menuItem.name} x${item.quantity} - ${item.totalPrice.toStringAsFixed(0)} FCFA",
        1,
        0,
      );
    }

    printer.printCustom("-----------------------------", 1, 1);
    printer.printCustom("TOTAL : ${cart.totalPrice.toStringAsFixed(0)} FCFA", 2, 1);
    printer.printNewLine();

    printer.printCustom(widget.isPaid ? "PAYÉ" : "À PAYER", 3, widget.isPaid ? 1 : 0);
    printer.printNewLine();
    printer.printNewLine();

    printer.paperCut(); // si supporté
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Ticket de commande")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Commande #${DateTime.now().millisecondsSinceEpoch % 100000}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...cart.items.map((item) => Text(
              "${item.menuItem.name} x${item.quantity} - ${item.totalPrice.toStringAsFixed(0)} FCFA",
              style: const TextStyle(fontSize: 16),
            )),
            const Divider(height: 32),
            Text(
              "TOTAL : ${cart.totalPrice.toStringAsFixed(0)} FCFA",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                widget.isPaid ? "Payé" : "À payer",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: widget.isPaid ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  cart.clearCart();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Retour à l'accueil"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

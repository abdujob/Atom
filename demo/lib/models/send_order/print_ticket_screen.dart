import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintTicketScreen extends StatefulWidget {
  const PrintTicketScreen({super.key});

  @override
  State<PrintTicketScreen> createState() => _PrintTicketScreenState();
}

class _PrintTicketScreenState extends State<PrintTicketScreen> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    // Demande les permissions nécessaires
    await Permission.bluetooth.request();
    await Permission.location.request();

    // Vérifie si Bluetooth est activé
    bool isOn = await bluetooth.isOn ?? false;
    if (!isOn) {
      // Redemande ou affiche une erreur
    }

    // Liste des imprimantes disponibles
    devices = await bluetooth.getBondedDevices();
    setState(() {});
  }

  void printTicket() {
    if (selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez sélectionner une imprimante.'),
      ));
      return;
    }

    bluetooth.connect(selectedDevice!).then((_) {
      bluetooth.printNewLine();
      bluetooth.printCustom("S'TACOS", 3, 1); // 3 = grand, 1 = centré
      bluetooth.printNewLine();
      bluetooth.printCustom("Ticket #001", 1, 0);
      bluetooth.printCustom("------------------------------", 1, 0);
      bluetooth.printLeftRight("Tacos Mix", "€6.00", 1);
      bluetooth.printLeftRight("Boisson", "€2.00", 1);
      bluetooth.printCustom("------------------------------", 1, 0);
      bluetooth.printLeftRight("TOTAL", "€8.00", 2);
      bluetooth.printNewLine();
      bluetooth.printCustom("Merci pour votre commande", 1, 1);
      bluetooth.printNewLine();
      bluetooth.paperCut(); // Certaines imprimantes la supportent
      bluetooth.disconnect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Impression Ticket")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Sélectionnez l'imprimante :"),
            DropdownButton<BluetoothDevice>(
              isExpanded: true,
              value: selectedDevice,
              hint: const Text("Aucune sélectionnée"),
              items: devices
                  .map(
                    (d) => DropdownMenuItem(
                  value: d,
                  child: Text(d.name ?? "Sans nom"),
                ),
              )
                  .toList(),
              onChanged: (device) {
                setState(() {
                  selectedDevice = device;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: printTicket,
              child: const Text("Imprimer le ticket"),
            )
          ],
        ),
      ),
    );
  }
}

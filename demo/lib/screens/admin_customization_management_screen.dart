import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/database_service.dart';

class AdminCustomizationManagementScreen extends StatefulWidget {
  const AdminCustomizationManagementScreen({super.key});

  @override
  State<AdminCustomizationManagementScreen> createState() => _AdminCustomizationManagementScreenState();
}

class _AdminCustomizationManagementScreenState extends State<AdminCustomizationManagementScreen> {
  List<CustomizationOption> _options = [];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  void _loadOptions() {
    setState(() {
      _options = DatabaseService.getAllCustomizationOptions();
    });
  }

  Future<void> _addOption() async {
    if (_nameController.text.trim().isEmpty || _imageUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final option = CustomizationOption(
      name: _nameController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0,
      imageUrl: _imageUrlController.text.trim(),
    );

    await DatabaseService.addCustomizationOption(option);
    _clearForm();
    _loadOptions();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Option ajoutée avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _imageUrlController.clear();
  }

  Future<void> _deleteOption(CustomizationOption option) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'option'),
        content: Text('Supprimer "${option.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseService.deleteCustomizationOption(option.name);
      _loadOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Options de personnalisation'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ajouter une nouvelle option',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'option',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Prix (F)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Chemin image',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addOption,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: _clearForm,
                        child: const Text('Effacer'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _options.isEmpty
                ? const Center(child: Text('Aucune option disponible'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(option.imageUrl),
                            onBackgroundImageError: (_, __) {},
                            child: option.imageUrl.isEmpty ? const Icon(Icons.restaurant) : null,
                          ),
                          title: Text(option.name),
                          subtitle: Text('Prix: ${option.price.toInt()} F'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteOption(option),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
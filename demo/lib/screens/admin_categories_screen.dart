import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/database_service.dart';
import '../widgets/smart_image.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = DatabaseService.getAllCategories();
    });
  }

  void _showAddEditDialog({Category? category}) {
    final isEdit = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    final iconController = TextEditingController(text: category?.iconUrl ?? '');
    final sortController = TextEditingController(
        text: category?.sortOrder.toString() ?? '0');
    bool isActive = category?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Modifier la catégorie' : 'Ajouter une catégorie'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la catégorie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(
                    labelText: 'URL de l\'icône',
                    border: OutlineInputBorder(),
                    hintText: 'assets/images/category.png',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: sortController,
                  decoration: const InputDecoration(
                    labelText: 'Ordre d\'affichage',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (value) {
                    setDialogState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    iconController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs requis'),
                    ),
                  );
                  return;
                }

                final newCategory = Category(
                  id: category?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  iconUrl: iconController.text.trim(),
                  sortOrder: int.tryParse(sortController.text) ?? 0,
                  isActive: isActive,
                );

                if (isEdit) {
                  await DatabaseService.updateCategory(newCategory);
                } else {
                  await DatabaseService.addCategory(newCategory);
                }

                _loadCategories();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEdit
                          ? 'Catégorie modifiée avec succès'
                          : 'Catégorie ajoutée avec succès'),
                    ),
                  );
                }
              },
              child: Text(isEdit ? 'Modifier' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la catégorie'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer la catégorie "${category.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseService.deleteCategory(category.id);
              _loadCategories();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catégorie supprimée')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Catégories'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _categories.isEmpty
          ? const Center(
              child: Text(
                'Aucune catégorie trouvée.\nAjoutez votre première catégorie !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category.isActive
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SmartImage(
                          category.iconUrl,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: category.isActive ? Colors.black : Colors.grey,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ordre: ${category.sortOrder}'),
                        Text(
                          category.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: category.isActive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showAddEditDialog(category: category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(category),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
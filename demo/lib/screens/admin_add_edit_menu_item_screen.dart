import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/menu_item.dart';
import '../services/database_service.dart';

class AdminAddEditMenuItemScreen extends StatefulWidget {
  final MenuItem? menuItem;

  const AdminAddEditMenuItemScreen({super.key, this.menuItem});

  @override
  State<AdminAddEditMenuItemScreen> createState() => _AdminAddEditMenuItemScreenState();
}

class _AdminAddEditMenuItemScreenState extends State<AdminAddEditMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  String? _selectedCategory;
  List<String> _categories = [];
  bool _isLoading = false;

  bool get _isEditing => widget.menuItem != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (_isEditing) {
      final item = widget.menuItem!;
      _nameController.text = item.name;
      _descriptionController.text = item.description;
      _priceController.text = item.price.toString();
      _imageUrlController.text = item.imageUrl;
      _selectedCategory = item.category;
    }
  }

  void _loadCategories() {
    final categories = DatabaseService.getAllCategories();
    setState(() {
      _categories = categories.map((category) => category.name).toList();
      if (_categories.isNotEmpty && _selectedCategory == null) {
        _selectedCategory = _categories.first;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String _generateId() {
    final name = _nameController.text.toLowerCase().replaceAll(' ', '_');
    final category = _selectedCategory?.toLowerCase() ?? 'unknown';
    return '${category}_$name';
  }

  Future<void> _saveMenuItem() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez d\'abord créer des catégories depuis l\'interface admin'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final menuItem = MenuItem(
        id: _isEditing ? widget.menuItem!.id : _generateId(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text.trim(),
        category: _selectedCategory!,
      );

      if (_isEditing) {
        await DatabaseService.updateMenuItem(menuItem);
      } else {
        await DatabaseService.addMenuItem(menuItem);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing 
                ? 'Article modifié avec succès' 
                : 'Article ajouté avec succès'
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier l\'article' : 'Ajouter un article'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveMenuItem,
            child: Text(
              _isEditing ? 'Modifier' : 'Ajouter',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations générales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de l\'article *',
                        prefixIcon: Icon(Icons.restaurant),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir le nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir la description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Prix (F) *',
                              prefixIcon: Icon(Icons.monetization_on),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Prix requis';
                              }
                              final price = double.tryParse(value);
                              if (price == null || price <= 0) {
                                return 'Prix invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: _categories.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Aucune catégorie disponible.\nCréez d\'abord des catégories.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  decoration: const InputDecoration(
                                    labelText: 'Catégorie *',
                                    prefixIcon: Icon(Icons.category),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _categories.map((category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Catégorie requise';
                                    }
                                    return null;
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Chemin de l\'image',
                        prefixIcon: Icon(Icons.image),
                        border: OutlineInputBorder(),
                        helperText: 'Ex: assets/images/mon_image.png',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir le chemin de l\'image';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_imageUrlController.text.isNotEmpty) ...[
                      const Text('Aperçu:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveMenuItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_isEditing ? Icons.save : Icons.add),
                          const SizedBox(width: 8),
                          Text(
                            _isEditing ? 'Sauvegarder les modifications' : 'Ajouter l\'article',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
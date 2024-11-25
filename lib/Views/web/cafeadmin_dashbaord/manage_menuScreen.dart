import 'package:flutter/material.dart';
import 'package:innovare_campus/controller/image_upload_service.dart';
import 'package:innovare_campus/model/menu_item.dart';
import 'package:innovare_campus/provider/menu_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ManageMenuScreen extends StatefulWidget {
  const ManageMenuScreen({super.key});

  @override
  _ManageMenuScreenState createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _imageUrl;
  String _selectedCategory = 'Desi';
  MenuItem? _editingItem;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final imageUrl = await uploadImageToFirebaseWeb();
      if (imageUrl.isNotEmpty) {
        setState(() {
          _imageUrl = imageUrl;
        });
      } else {
        _showSnackBar('Failed to upload image. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred while uploading the image.');
    }
  }

  Future<void> _addOrUpdateMenuItem() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    final menuProvider = Provider.of<MenuProvider>(context, listen: false);

    String menuItemId = _editingItem?.id ?? menuProvider.getNewDocumentId();

    final menuItem = MenuItem(
      id: menuItemId,
      name: _nameController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrl ?? '',
      category: _selectedCategory,
    );

    try {
      if (_editingItem == null) {
        // Add new item
        await menuProvider.addMenuItem(menuItem);
        _showSnackBar('Item added successfully!');
      } else {
        // Update existing item
        await menuProvider.updateMenuItem(menuItem);
        _showSnackBar('Item updated successfully!');
      }
    } catch (e) {
      _showSnackBar('An error occurred while saving the item.');
    }

    _clearForm();
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    setState(() {
      _imageUrl = null;
      _selectedCategory = 'Desi';
      _editingItem = null;
    });
  }

  void _editMenuItem(MenuItem item) {
    setState(() {
      _editingItem = item;
      _nameController.text = item.name;
      _priceController.text = item.price.toString();
      _imageUrl = item.imageUrl;
      _selectedCategory = item.category;
    });
  }

  void _deleteMenuItem(MenuItem item) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    menuProvider.deleteMenuItem(item);
    _showSnackBar('Item deleted successfully!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _refreshMenu() async {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    await menuProvider.fetchMenuItems();
    _showSnackBar('Menu items refreshed!');
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingItem == null ? 'Manage Menu' : 'Edit Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMenu,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Item Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['Desi', 'Fast Food', 'Drinks']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            _imageUrl == null
                ? const Icon(Icons.image, size: 150)
                : Image.network(_imageUrl!, height: 150, fit: BoxFit.cover),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateMenuItem,
              child: Text(_editingItem == null ? 'Add Item' : 'Update Item'),
            ),
            if (_editingItem != null)
              ElevatedButton(
                onPressed: _clearForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const Text('Cancel Editing'),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCategorySection('Desi', menuProvider),
                  _buildCategorySection('Fast Food', menuProvider),
                  _buildCategorySection('Drinks', menuProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, MenuProvider menuProvider) {
    final items = menuProvider.menuItems
        .where((item) => item.category == category)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...items.map((item) => ListTile(
              leading: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return const Icon(Icons.error,
                            size: 50); // Placeholder icon
                      },
                    )
                  : const Icon(Icons.image,
                      size: 50), // Default icon if no image
              title: Text(item.name),
              subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editMenuItem(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteMenuItem(item),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:innovare_campus/controller/image_upload_service.dart';
import 'package:innovare_campus/model/menu_item.dart';
import 'package:innovare_campus/provider/menu_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ManageMenuScreen extends StatefulWidget {
  @override
  _ManageMenuScreenState createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _imageUrl;
  String _selectedCategory = 'Desi'; // Default category
  MenuItem? _editingItem; // For tracking the item being edited

  @override
  void initState() {
    super.initState();
    // Initialize data or fetch initial data if necessary
  }

  Future<void> _pickImage() async {
    try {
      final imageUrl = await uploadImageToFirebaseWeb();
      if (imageUrl.isNotEmpty) {
        setState(() {
          _imageUrl = imageUrl; // Set the image URL after upload
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

    // If it's a new item, generate a new document ID
    String menuItemId = _editingItem?.id ?? menuProvider.getNewDocumentId();

    final menuItem = MenuItem(
      id: menuItemId, // Use either the editing item ID or a new one
      name: _nameController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrl ?? '', // Use the uploaded image URL
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
      _selectedCategory = 'Desi'; // Reset to default category
      _editingItem = null; // Clear editing state
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
            icon: Icon(Icons.refresh),
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
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Item Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            _imageUrl == null
                ? Icon(Icons.image,
                    size: 150) // Placeholder icon if no image URL
                : Image.network(_imageUrl!, height: 150, fit: BoxFit.cover),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateMenuItem,
              child: Text(_editingItem == null ? 'Add Item' : 'Update Item'),
            ),
            if (_editingItem != null)
              ElevatedButton(
                onPressed: _clearForm,
                child: Text('Cancel Editing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
            SizedBox(height: 20),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        return Icon(Icons.error, size: 50); // Placeholder icon
                      },
                    )
                  : Icon(Icons.image, size: 50), // Default icon if no image
              title: Text(item.name),
              subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editMenuItem(item),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteMenuItem(item),
                  ),
                ],
              ),
            )),
        SizedBox(height: 20),
      ],
    );
  }
}

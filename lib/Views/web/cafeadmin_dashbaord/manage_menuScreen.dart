import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovare_campus/controller/image_upload_service.dart';
import 'package:innovare_campus/model/menu_item.dart';
import 'package:innovare_campus/provider/menu_provider.dart';
import 'package:provider/provider.dart';

class ManageMenuScreen extends StatefulWidget {
  @override
  _ManageMenuScreenState createState() => _ManageMenuScreenState();
}

class _ManageMenuScreenState extends State<ManageMenuScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _imageUrl;
  XFile? _imageFile;
  String _selectedCategory = 'Desi'; // Default category
  MenuItem? _editingItem; // For tracking the item being edited

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
      final imageUrl = await uploadImageToFirebase(_imageFile!);
      if (imageUrl.isNotEmpty) {
        setState(() {
          _imageUrl = imageUrl;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
      }
    }
  }

  Future<void> _addOrUpdateMenuItem() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final menuItem = MenuItem(
      id: _editingItem?.id ?? '', // ID will be assigned by Firestore if new
      name: _nameController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrl ?? '', // Default to empty string if no image
      category: _selectedCategory,
    );

    final menuProvider = Provider.of<MenuProvider>(context, listen: false);

    if (_editingItem == null) {
      // Add new item
      menuProvider.addMenuItem(menuItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully!')),
      );
    } else {
      // Update existing item
      menuProvider.updateMenuItem(menuItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item updated successfully!')),
      );
    }

    _clearForm();
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    setState(() {
      _imageUrl = null;
      _imageFile = null;
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingItem == null ? 'Manage Menu' : 'Edit Item'),
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
                ? Text('No image selected.')
                : Image.network(_imageUrl!, height: 150), // Use Image.network to display the uploaded image
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
    final items = menuProvider.menuItems.where((item) => item.category == category).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...items.map((item) => ListTile(
              leading: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image, size: 50), // Display default icon if no image
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

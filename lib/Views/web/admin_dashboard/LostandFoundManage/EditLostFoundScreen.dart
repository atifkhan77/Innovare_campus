import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/lostfind.dart';

class EditLostFoundScreen extends StatefulWidget {
  final LostFoundItem item;

  const EditLostFoundScreen({Key? key, required this.item}) : super(key: key);

  @override
  _EditLostFoundScreenState createState() => _EditLostFoundScreenState();
}

class _EditLostFoundScreenState extends State<EditLostFoundScreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.item.description);
    _locationController = TextEditingController(text: widget.item.location);
    _imageUrlController = TextEditingController(text: widget.item.imageUrl);
  }

  Future<void> updateItem() async {
    final updatedItem = LostFoundItem(
      id: widget.item.id,
      description: _descriptionController.text,
      location: _locationController.text,
      imageUrl: _imageUrlController.text,
      timestamp: widget.item.timestamp,
    );

    await FirebaseFirestore.instance
        .collection('lost_found')
        .doc(widget.item.id)
        .update(updatedItem.toMap());

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: updateItem,
              child: const Text('Update Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

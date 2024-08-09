import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:innovare_campus/model/document.dart';
import 'package:innovare_campus/provider/document_provider.dart';
import 'package:provider/provider.dart';

class PrintScreen extends StatefulWidget {
  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  PlatformFile? _selectedFile;
  String? userId; // Change to nullable

  @override
  void initState() {
    super.initState();
    // Fetch the user ID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    if (userId != null) {
      Provider.of<DocumentProvider>(context, listen: false).fetchDocuments(userId!); // Fetch user's documents
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _submitFile(BuildContext context) async {
    if (_selectedFile != null && userId != null) {
      await Provider.of<DocumentProvider>(context, listen: false).uploadDocument(_selectedFile!, userId!); // Pass the userId
      setState(() {
        _selectedFile = null;
      });

      // Show submission confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print Documents'),
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, documentProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Welcome back, Printer',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Upload your files'),
              ),
              if (_selectedFile != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Selected file: ${_selectedFile!.name}'),
                    ),
                    ElevatedButton(
                      onPressed: () => _submitFile(context),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: documentProvider.documents.length,
                  itemBuilder: (context, index) {
                    Document document = documentProvider.documents[index];
                    return ListTile(
                      title: Text(document.name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          documentProvider.deleteDocument(document.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

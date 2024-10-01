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
  String? userId;
  int _numOfPrints = 1;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    if (userId != null) {
      Provider.of<DocumentProvider>(context, listen: false)
          .fetchDocuments(userId!);
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _submitFile(BuildContext context) async {
    if (_selectedFile != null && userId != null) {
      await Provider.of<DocumentProvider>(context, listen: false)
          .uploadDocument(_selectedFile!, userId!, _numOfPrints);
      setState(() {
        _selectedFile = null;
        _numOfPrints = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text('Print Documents'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Splash.png',
              fit: BoxFit.cover,
            ),
          ),
          Consumer<DocumentProvider>(
            builder: (context, documentProvider, child) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Welcome back, Printer',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 0, 70, 1)),
                    onPressed: _pickFile,
                    child: const Text('Upload your files',
                        style: TextStyle(color: Colors.white)),
                  ),
                  if (_selectedFile != null)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Selected file: ${_selectedFile!.name}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Number of prints'),
                            initialValue: '1',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _numOfPrints = int.parse(value);
                              });
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(0, 0, 70, 1),
                          ),
                          onPressed: () => _submitFile(context),
                          child: const Text('Submit',
                              style: TextStyle(color: Colors.white)),
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
                          subtitle:
                              Text('Number of prints: ${document.numOfPrints}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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
        ],
      ),
    );
  }
}

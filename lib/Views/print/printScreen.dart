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
      Provider.of<DocumentProvider>(context, listen: false)
          .fetchDocuments(userId!); // Fetch user's documents
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void _submitFile(BuildContext context) async {
    if (_selectedFile != null && userId != null) {
      await Provider.of<DocumentProvider>(context, listen: false)
          .uploadDocument(_selectedFile!, userId!); // Pass the userId
      setState(() {
        _selectedFile = null;
      });

      // Show submission confirmation message
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
        title: const Text(
          'Print Documents',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/Splash.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
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
                    child: const Text(
                      'Upload your files',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (_selectedFile != null)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Selected file: ${_selectedFile!.name}'),
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
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: documentProvider.documents.length,
                      itemBuilder: (context, index) {
                        Document document = documentProvider.documents[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal:
                                  10), // Adds margin around each ListTile
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(
                                0.3), // Semi-transparent background color
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            title: Text(
                              document.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16), // Adjusts text color and size
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                documentProvider.deleteDocument(document.id);
                              },
                            ),
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

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:innovare_campus/model/document.dart';
import 'package:uuid/uuid.dart';

class DocumentProvider extends ChangeNotifier {
  List<Document> _documents = [];

  List<Document> get documents => _documents;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch documents for the given userId
  Future<void> fetchDocuments(String userId) async {
    QuerySnapshot querySnapshot = await _firestore.collection('prints')
      .where('userId', isEqualTo: userId) // Fetch only the user's documents
      .get();
    
    _documents = querySnapshot.docs.map((doc) => Document.fromFirestore(doc)).toList();
    notifyListeners();
  }

  // Upload a document with numOfPrints field
  Future<void> uploadDocument(PlatformFile file, String userId, int numOfPrints) async {
    try {
      String fileId = Uuid().v4();
      String fileName = file.name;

      // Upload file to Firebase Storage
      Reference ref = _storage.ref().child('documents/$fileId.pdf');
      UploadTask uploadTask = ref.putData(file.bytes!);
      await uploadTask;

      String downloadURL = await ref.getDownloadURL();

      // Save document info to Firestore, including numOfPrints
      await _firestore.collection('prints').doc(fileId).set({
        'id': fileId,
        'name': fileName,
        'url': downloadURL,
        'userId': userId, // Save the userId along with the document
        'uploadedAt': Timestamp.now(),
        'numOfPrints': numOfPrints, // Save the number of prints
      });

      // Add document to local list and notify listeners
      _documents.add(Document(
        id: fileId,
        name: fileName,
        url: downloadURL,
        userId: userId,
        numOfPrints: numOfPrints,
      ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Delete a document
  Future<void> deleteDocument(String id) async {
    try {
      // Delete file from Firebase Storage
      await _storage.ref().child('documents/$id.pdf').delete();

      // Delete document info from Firestore
      await _firestore.collection('prints').doc(id).delete();

      // Remove document from local list and notify listeners
      _documents.removeWhere((doc) => doc.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

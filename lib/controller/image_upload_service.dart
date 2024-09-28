import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html;


import 'package:flutter/material.dart';


Future<String> uploadImageToFirebaseWeb() async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    // Wait for the user to select a file
    await uploadInput.onChange.first;
    final file = uploadInput.files?.first;
    if (file == null) {
      throw Exception('No file selected');
    }

    // Read the file as a Data URL to display it
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;

    // Create a reference to the Firebase Storage location and upload the file
    final uploadTask = storageRef.child('menu/${file.name}').putBlob(file);

    // Monitor upload progress
    uploadTask.snapshotEvents.listen((event) {
      final progress = (event.bytesTransferred / event.totalBytes) * 100;
      print('Upload is ${progress.toStringAsFixed(2)}% complete');
    });

    // Wait for the upload to complete
    final snapshot = await uploadTask.whenComplete(() {});

    // Get the download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return '';
  }
}

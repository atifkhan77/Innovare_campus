import 'package:firebase_storage/firebase_storage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

Future<String> uploadImageToFirebaseWeb() async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;
    final file = uploadInput.files?.first;
    if (file == null) {
      throw Exception('No file selected');
    }

    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;

    final uploadTask = storageRef.child('menu/${file.name}').putBlob(file);

    uploadTask.snapshotEvents.listen((event) {
      final progress = (event.bytesTransferred / event.totalBytes) * 100;
      debugPrint('Upload is ${progress.toStringAsFixed(2)}% complete');
    });

    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    debugPrint('Error uploading image: $e');
    return '';
  }
}

import 'package:firebase_storage/firebase_storage.dart';
<<<<<<< HEAD
import 'dart:html' as html;

// Function to upload image to Firebase (for web)
Future<String> uploadImageToFirebaseWeb() async {
  final storageRef = FirebaseStorage.instance.ref();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  await uploadInput.onChange.first;
  final file = uploadInput.files?.first;
  if (file == null) return '';

  final reader = html.FileReader();
  reader.readAsDataUrl(file);
  await reader.onLoad.first;

  final uploadTask = storageRef.child('menu/${file.name}').putBlob(file);
  final snapshot = await uploadTask.whenComplete(() {});
  final downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
=======
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImageToFirebase(XFile image) async {
  try {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref =
        FirebaseStorage.instance.ref().child('menu_images').child(fileName);

    final uploadTask = ref.putFile(File(image.path));
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    debugPrint('Error uploading image: $e');
    return '';
  }
>>>>>>> 8814b96e78e813608943b356d2a6b6e56e8f7b2c
}

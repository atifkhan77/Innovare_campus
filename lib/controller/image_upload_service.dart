import 'package:firebase_storage/firebase_storage.dart';
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
}

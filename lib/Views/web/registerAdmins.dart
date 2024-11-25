import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> registerAdmins() async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await auth.createUserWithEmailAndPassword(
      email: 'admin@example.com',
      password: 'adminpassword',
    );

    await auth.createUserWithEmailAndPassword(
      email: 'cafeadmin@example.com',
      password: 'cafepassword',
    );

    debugPrint('Admins registered successfully');
  } catch (e) {
    debugPrint('Error registering admins: $e');
  }
}

void main() async {
  await registerAdmins();
}

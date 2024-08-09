import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:innovare_campus/provider/newsProvider.dart';
import 'package:innovare_campus/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/manage_menuScreen.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:innovare_campus/provider/lostfound_provider.dart';
import 'package:innovare_campus/provider/document_provider.dart';
import 'package:innovare_campus/provider/menu_provider.dart';
import 'package:innovare_campus/Views/web/admin_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment this line only during development
  // await registerAdmins();

  runApp(MyWebApp());
}

Future<void> registerAdmins() async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Register admin user
    await _auth.createUserWithEmailAndPassword(
      email: 'admin@example.com',
      password: 'adminpassword',
    );

    // Register cafe admin user
    await _auth.createUserWithEmailAndPassword(
      email: 'cafeadmin@example.com',
      password: 'cafepassword',
    );

    print('Admins registered successfully');
  } catch (e) {
    print('Error registering admins: $e');
  }
}

class MyWebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TutorProvider()),
        ChangeNotifierProvider(create: (context) => LostFoundProvider()),
        ChangeNotifierProvider(create: (context) => DocumentProvider()),
        ChangeNotifierProvider(create: (context) => MenuProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
         ChangeNotifierProvider(create: (context) => NewsProvider()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminScreen(),
        routes: {
          '/manage-menu': (context) => ManageMenuScreen(), // Add route for ManageMenuScreen
        },
      ),
    );
  }
}

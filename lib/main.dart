import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/print/printScreen.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:innovare_campus/provider/lostfound_provider.dart';
import 'package:innovare_campus/provider/document_provider.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/Views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TutorProvider()),
        ChangeNotifierProvider(create: (context) => LostFoundProvider()),
        ChangeNotifierProvider(create: (context) => DocumentProvider()), // Added DocumentProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          '/print': (context) => PrintScreen(), // Added route for PrintScreen
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:innovare_campus/Views/print/printScreen.dart';
import 'package:innovare_campus/provider/cafeOrder_provider.dart';
import 'package:innovare_campus/provider/cart_provider.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:innovare_campus/provider/lostfound_provider.dart';
import 'package:innovare_campus/provider/document_provider.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/Views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     'pk_test_51PmfD1EfHzJkiA2Ln4yXcJ5jq4AJW4FejpV86LLf0LbmnrzXt0g1l4JW99yrik5o24c8rsg0gl5cpcqvOrYH53Uc002TujdoIG';
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
        ChangeNotifierProvider(create: (context) => DocumentProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
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

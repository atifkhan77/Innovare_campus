import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


const String stripeSecretKey = 'sk_test_51PmfD1EfHzJkiA2Llqz7bKux8loa2v1MnClAcz88YuLzw0IL9875lt25dc6HqXmlfzRrAqiYMoRKlqlOoYCoOoXB00na9oQpmh';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(String shopName, int amountInPkr, String usersEmail) async {
    print("Make Payment method called");

    // Fetch customer data from Firestore
    final usersData = await fetchUserData(usersEmail);
    String? customerName = usersData?['name'];
    String? customerEmail = usersData?['email'];

    print("Customer Name: ${customerName ?? 'null'}, Email: ${customerEmail ?? 'null'}");

    if (customerName == null || customerEmail == null) {
      print("Customer details are missing. Please ensure they are correctly stored in Firestore.");
      return; // Exit if customer details are missing
    }

    try {
      print("Initializing Stripe payment method");

      // Create Stripe customer
      final customer = await createCustomer(customerName, customerEmail);
      print("Customer created: $customer");

      // Create payment intent in USD
      String? paymentIntentClientSecret = await _createPaymentIntent(amountInPkr, "usd");
      if (paymentIntentClientSecret == null) {
        print("Failed to create payment intent.");
        return; // Exit if payment intent creation failed
      }

      // Initialize Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: shopName,
        ),
      );

      // Present payment sheet
      await _processPayment();
    } on StripeException catch (s) {
      print("StripeException: ${s.error.message}");
      throw Exception("Error in Stripe exception: ${s.error.message}");
    } catch (e) {
      print("Exception: $e");
      throw Exception("Error in Stripe catch: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String email) async {
    try {
      // Fetch user document from Firestore
      final querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final data = document.data();
        final name = data['name'] as String?;
        final email = data['email'] as String?;
        return {
          'name': name ?? '',
          'email': email ?? ''
        };
      } else {
        print("No user found with email: $email");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>> createCustomer(String fullName, String email) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization': 'Bearer $stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': fullName,
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register as a customer. Status code: ${response.statusCode}');
    }
  }

  Future<String?> _createPaymentIntent(int amountInPkr, String currency) async {
    try {
      // Step 1: Fetch conversion rate from an external API
      double conversionRate = await _fetchConversionRate(); // Example: 1 USD = 300 PKR

      // Step 2: Convert PKR to USD
      double amountInUsd = amountInPkr / conversionRate;

      // Convert amount to cents (or smallest currency unit)
      int amountInCents = (amountInUsd * 100).round();

      // Log conversion rate and amount
      print("Conversion Rate: $conversionRate");
      print("Amount in USD: $amountInUsd");
      print("Amount in Cents: $amountInCents");

      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": amountInCents.toString(), // USD cents
        "currency": currency, // Use USD as the currency
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Payment Intent Created: ${response.data}");
        return response.data["client_secret"];
      } else {
        print("Failed to create payment intent. Status code: ${response.statusCode}");
        print("Response body: ${response.data}");
      }
    } catch (e) {
      print("Error creating payment intent: $e");
    }
    return null;
  }

  Future<double> _fetchConversionRate() async {
    // Fetch real-time conversion rate from a chosen API
    // Replace with actual implementation
    return 100.0; // Example rate
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment successful.");
     
    } catch (e) {
      print("Payment failed: $e");
    }
  }
}
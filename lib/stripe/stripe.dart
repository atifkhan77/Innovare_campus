import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

const String stripeSecretKey =
    'sk_test_51PmfD1EfHzJkiA2Llqz7bKux8loa2v1MnClAcz88YuLzw0IL9875lt25dc6HqXmlfzRrAqiYMoRKlqlOoYCoOoXB00na9oQpmh';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(
      String shopName, int amountInPkr, String usersEmail) async {
    debugPrint("Make Payment method called");

    final usersData = await fetchUserData(usersEmail);
    String? customerName = usersData?['name'];
    String? customerEmail = usersData?['email'];

    debugPrint(
        "Customer Name: ${customerName ?? 'null'}, Email: ${customerEmail ?? 'null'}");

    if (customerName == null || customerEmail == null) {
      debugPrint(
          "Customer details are missing. Please ensure they are correctly stored in Firestore.");
      return;
    }

    try {
      debugPrint("Initializing Stripe payment method");

      final customer = await createCustomer(customerName, customerEmail);
      debugPrint("Customer created: $customer");

      String? paymentIntentClientSecret =
          await _createPaymentIntent(amountInPkr, "usd");
      if (paymentIntentClientSecret == null) {
        debugPrint("Failed to create payment intent.");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: shopName,
        ),
      );

      await _processPayment();
    } on StripeException catch (s) {
      debugPrint("StripeException: ${s.error.message}");
      throw Exception("Error in Stripe exception: ${s.error.message}");
    } catch (e) {
      debugPrint("Exception: $e");
      throw Exception("Error in Stripe catch: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String email) async {
    try {
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
        return {'name': name ?? '', 'email': email ?? ''};
      } else {
        debugPrint("No user found with email: $email");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>> createCustomer(
      String fullName, String email) async {
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
      throw Exception(
          'Failed to register as a customer. Status code: ${response.statusCode}');
    }
  }

  Future<String?> _createPaymentIntent(int amountInPkr, String currency) async {
    try {
      double conversionRate = await _fetchConversionRate();

      double amountInUsd = amountInPkr / conversionRate;

      int amountInCents = (amountInUsd * 100).round();

      debugPrint("Conversion Rate: $conversionRate");
      debugPrint("Amount in USD: $amountInUsd");
      debugPrint("Amount in Cents: $amountInCents");

      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": amountInCents.toString(),
        "currency": currency,
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
        debugPrint("Payment Intent Created: ${response.data}");
        return response.data["client_secret"];
      } else {
        debugPrint(
            "Failed to create payment intent. Status code: ${response.statusCode}");
        debugPrint("Response body: ${response.data}");
      }
    } catch (e) {
      debugPrint("Error creating payment intent: $e");
    }
    return null;
  }

  Future<double> _fetchConversionRate() async {
    return 100.0;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      debugPrint("Payment successful.");
    } catch (e) {
      debugPrint("Payment failed: $e");
    }
  }
}

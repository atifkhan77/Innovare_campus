import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

class DialogflowService {
  static const _dialogflowURL = "https://dialogflow.googleapis.com/v2/projects/comsatsbot-ktqv/agent/sessions/1234567890:detectIntent";

  Future<String> getResponse(String query) async {
    // Load the service account credentials from JSON
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(await rootBundle.loadString('assets/your-service-account.json')),
    );

    // Create the HTTP client using the service account credentials
    final client = await clientViaServiceAccount(serviceAccountCredentials, [
      'https://www.googleapis.com/auth/cloud-platform',
    ]);

    // Build the request body
    final Map<String, dynamic> body = {
      "queryInput": {
        "text": {
          "text": query,
          "languageCode": "en"
        }
      }
    };

    // Send the POST request to Dialogflow
    final response = await client.post(
      Uri.parse(_dialogflowURL),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    // Parse the response from Dialogflow
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String fulfillmentText = jsonResponse['queryResult']['fulfillmentText'];
      return fulfillmentText;
    } else {
      throw Exception("Failed to load response from Dialogflow API");
    }
  }
}

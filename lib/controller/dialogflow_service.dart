import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;

class DialogflowService {
  static const _dialogflowURL =
      "https://dialogflow.googleapis.com/v2/projects/comsats-bot-p9fw/agent/sessions/1234567890:detectIntent";

  Future<String> getResponse(String query) async {
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(
      json.decode(
          await rootBundle.loadString('assets/your-service-account.json')),
    );

    final client = await clientViaServiceAccount(serviceAccountCredentials, [
      'https://www.googleapis.com/auth/cloud-platform',
    ]);

    final Map<String, dynamic> body = {
      "queryInput": {
        "text": {"text": query, "languageCode": "en"}
      }
    };

    final response = await client.post(
      Uri.parse(_dialogflowURL),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String fulfillmentText =
          jsonResponse['queryResult']['fulfillmentText'];
      return fulfillmentText;
    } else {
      throw Exception("Failed to load response from Dialogflow API");
    }
  }
}

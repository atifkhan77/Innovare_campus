import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/model/society.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package to your pubspec.yaml

class SocietyDetailsScreen extends StatelessWidget {
  final Society society;

  SocietyDetailsScreen({required this.society});

  // Function to launch URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to create TextSpan with URL detection
  TextSpan _createTextSpan(String text) {
    final RegExp urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
      multiLine: false,
    );

    final matches = urlRegex.allMatches(text);
    if (matches.isEmpty) {
      return TextSpan(text: text);
    }

    final textSpans = <TextSpan>[];
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        textSpans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
        ));
      }
      textSpans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()..onTap = () => _launchURL(match.group(0)!),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      textSpans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return TextSpan(children: textSpans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(society.name),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(society.description),
            SizedBox(height: 8.0),
            Text('Recruitment Drive:', style: TextStyle(fontWeight: FontWeight.bold)),
            RichText(
              text: _createTextSpan(society.recruitmentDrive),
            ),
            SizedBox(height: 8.0),
            Text('Upcoming Event:', style: TextStyle(fontWeight: FontWeight.bold)),
            RichText(
              text: _createTextSpan(society.upcomingEvent),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/model/society.dart';
import 'package:url_launcher/url_launcher.dart';

class SocietyDetailsScreen extends StatelessWidget {
  final Society society;

  const SocietyDetailsScreen({super.key, required this.society});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _launchURL(match.group(0)!),
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
        title: Text(
          society.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Fullscreen Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/Splash.png', // Path to your splash image
              fit: BoxFit.cover, // Ensures the image covers the full screen
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: _createTextSpan(society.description),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Recruitment Drive:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: _createTextSpan(society.recruitmentDrive),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Upcoming Event:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: _createTextSpan(society.upcomingEvent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

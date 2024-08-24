import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  const ChatBubble({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Splash.png", // Background image
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const ChatBubble(
                message: "Welcome to Innovare_Campus",
              ),
              // Additional notifications can be added here
              // Use Expanded to fill the rest of the space if needed
              Expanded(child: Container()), // This ensures the Column fills the remaining space
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:innovare_campus/Views/chat/chatScreen.dart';
import 'package:innovare_campus/Views/home.dart';
import 'package:innovare_campus/Views/notifications/notificationsScreen.dart';

class UiHelper {
  static CustomTextField(TextEditingController controller, String text,
      bool hide, IconData iconData) {
    return TextField(
      controller: controller,
      obscureText: hide,
      decoration: InputDecoration(hintText: text),
    );
  }

  static customText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromRGBO(0, 0, 70, 1),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromRGBO(49, 42, 119, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 40,
            icon: const Icon(
              color: Colors.white70,
              Icons.home_sharp,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        userId: '',
                      )));
            },
          ),
          IconButton(
            color: Colors.white70,
            iconSize: 35,
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ChatScreen()));
              // Add functionality for notification icon here
            },
          ),
          IconButton(
            color: Colors.white70,
            iconSize: 35,
            icon: const Icon(Icons.assistant_navigation),
            onPressed: () {
              // Add functionality for settings icon here
            },
          ),
          IconButton(
            color: Colors.white70,
            iconSize: 35,
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class CardComponent extends StatelessWidget {
  final String title;
  final String assetPath;
  final VoidCallback onTap;

  const CardComponent({
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: const Color.fromRGBO(131, 18, 253, 0.17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 50,
              height: 50,
            ),
            Container(
              // Use Container to wrap the Divider
              height: 2, // Set the initial height of the line
              width: 60, // Make the line expand to full width
              color: Colors.white70, // Set the color of the line
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

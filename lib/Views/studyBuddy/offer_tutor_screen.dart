import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/userManagment/profileScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/model/tutor.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:provider/provider.dart';


class OfferTutorScreen extends StatelessWidget {
  const OfferTutorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    String availability = 'Morning'; // Default value

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/placeholder.png'),
              ),
            ),
            const Text(
              'Welcome back, Tanzeel',
              style: TextStyle(color: Colors.white70),
            ),
            const Icon(Icons.school), // placeholder icon
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'StudyBuddy',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: 'Subject Expertise',
                      hintText: 'Enter your subject expertise',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Availability',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ChoiceChip(
                        label: Text('Morning'),
                        selected: availability == 'Morning',
                        onSelected: (selected) {
                          availability = 'Morning';
                        },
                      ),
                      ChoiceChip(
                        label: Text('Afternoon'),
                        selected: availability == 'Afternoon',
                        onSelected: (selected) {
                          availability = 'Afternoon';
                        },
                      ),
                      ChoiceChip(
                        label: Text('Evening'),
                        selected: availability == 'Evening',
                        onSelected: (selected) {
                          availability = 'Evening';
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Tutor Name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: contactController,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      hintText: 'Enter your number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final tutor = Tutor(
                          name: nameController.text,
                          subjectExpertise: subjectController.text,
                          availability: availability,
                          contactNumber: contactController.text,
                        );
                        Provider.of<TutorProvider>(context, listen: false).addTutor(tutor);
                        // Clear fields after submission
                        nameController.clear();
                        subjectController.clear();
                        contactController.clear();
                        // Show a confirmation message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tutor submitted successfully')),
                        );
                      },
                      child: Text('Submit Tutor'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(), // assuming you have a NavBar widget
    );
  }
}

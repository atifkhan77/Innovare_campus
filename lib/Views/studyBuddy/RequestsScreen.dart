import 'package:flutter/material.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text('View Requests'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Splash.png"), // Update the image path if necessary
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: Future.wait([
              Provider.of<TutorProvider>(context, listen: false).fetchCurrentTutor(),
              Provider.of<TutorProvider>(context, listen: false).fetchRequests(),
            ]),
            builder: (context, AsyncSnapshot<List<void>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return Consumer<TutorProvider>(
                builder: (context, tutorProvider, child) {
                  final String? tutorName = tutorProvider.tutorName;

                  if (tutorName == null) {
                    return const Center(child: Text('Tutor not found'));
                  }

                  final pendingRequests = tutorProvider.requests
                      .where((r) => r.status == 'pending' && r.tutorName == tutorName)
                      .toList();
                  final acceptedRequests = tutorProvider.requests
                      .where((r) => r.status == 'accepted' && r.tutorName == tutorName)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'StudyBuddy',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Pending Requests',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pendingRequests.length,
                          itemBuilder: (context, index) {
                            final request = pendingRequests[index];
                            return ListTile(
                              leading: const Icon(Icons.person, color: Colors.white),
                              title: Text(request.studentName, style: const TextStyle(color: Colors.white)),
                              subtitle: Text(request.message, style: const TextStyle(color: Colors.white)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () {
                                      Provider.of<TutorProvider>(context, listen: false).acceptRequest(request.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      Provider.of<TutorProvider>(context, listen: false).declineRequest(request.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Accepted Requests',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: acceptedRequests.length,
                          itemBuilder: (context, index) {
                            final request = acceptedRequests[index];
                            return ListTile(
                              leading: const Icon(Icons.person, color: Colors.white),
                              title: Text(request.studentName, style: const TextStyle(color: Colors.white)),
                              subtitle: Text(request.message, style: const TextStyle(color: Colors.white)),
                              trailing: Text(request.status, style: const TextStyle(color: Colors.white)),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

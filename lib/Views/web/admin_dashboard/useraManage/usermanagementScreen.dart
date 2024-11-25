import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/Adminwidgets/drawers.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/useraManage/addUserScreen.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/useraManage/editUserScreen.dart';
import 'package:innovare_campus/provider/userProvider.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              userProvider.refreshUsers();
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: userProvider.users.length,
          itemBuilder: (context, index) {
            final user = userProvider.users[index];
            return _buildUserCard(context, userProvider, user);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add User"),
      ),
    );
  }

  Widget _buildUserCard(
      BuildContext context, UserProvider userProvider, var user) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(49, 42, 119, 1),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl),
              radius: 30.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(user: user),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                userProvider.deleteUser(user);
              },
            ),
          ],
        ),
      ),
    );
  }
}

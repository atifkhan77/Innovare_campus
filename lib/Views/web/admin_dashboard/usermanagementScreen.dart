import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/addUserScreen.dart';
import 'package:innovare_campus/Views/web/admin_dashboard/editUserScreen.dart';
import 'package:innovare_campus/provider/userProvider.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              userProvider.refreshUsers(); // Refresh the user list
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
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
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    userProvider.deleteUser(user);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

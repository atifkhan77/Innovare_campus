import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/Adminwidgets/drawers.dart';
import 'package:innovare_campus/model/society.dart';
import 'package:innovare_campus/provider/society_provider.dart';
import 'package:provider/provider.dart';

class SocietyManagementScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _upcomingEventController =
      TextEditingController();
  final TextEditingController _recruitmentDriveController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Societies',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      drawer: CustomDrawer(),
      body: Consumer<SocietyProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.societies.length,
            itemBuilder: (context, index) {
              final society = provider.societies[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    society.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(society.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _nameController.text = society.name;
                          _descriptionController.text = society.description;
                          _upcomingEventController.text = society.upcomingEvent;
                          _recruitmentDriveController.text =
                              society.recruitmentDrive;
                          _showEditDialog(context, society);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<SocietyProvider>(context, listen: false)
                              .deleteSociety(society.id);
                          _showSnackBar(
                              context, 'Society deleted successfully');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          _descriptionController.clear();
          _upcomingEventController.clear();
          _recruitmentDriveController.clear();
          _showAddDialog(context);
        },
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Society society) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Society'),
          content: _buildDialogContent(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedSociety = Society(
                  id: society.id,
                  name: _nameController.text,
                  description: _descriptionController.text,
                  upcomingEvent: _upcomingEventController.text,
                  recruitmentDrive: _recruitmentDriveController.text,
                );
                Provider.of<SocietyProvider>(context, listen: false)
                    .updateSociety(updatedSociety);
                Navigator.pop(context);
                _showSnackBar(context, 'Society updated successfully');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Society'),
          content: _buildDialogContent(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newSociety = Society(
                  id: '',
                  name: _nameController.text,
                  description: _descriptionController.text,
                  upcomingEvent: _upcomingEventController.text,
                  recruitmentDrive: _recruitmentDriveController.text,
                );
                Provider.of<SocietyProvider>(context, listen: false)
                    .addSociety(newSociety);
                Navigator.pop(context);
                _showSnackBar(context, 'Society added successfully');
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _upcomingEventController,
            decoration:
                const InputDecoration(labelText: 'Upcoming Event (optional)'),
          ),
          TextField(
            controller: _recruitmentDriveController,
            decoration: const InputDecoration(
                labelText: 'Recruitment Drive (optional)'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

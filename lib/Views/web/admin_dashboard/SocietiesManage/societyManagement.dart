import 'package:flutter/material.dart';
import 'package:innovare_campus/model/society.dart';
import 'package:innovare_campus/provider/society_provider.dart';
import 'package:provider/provider.dart';

class SocietyManagementScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _upcomingEventController = TextEditingController();
  final TextEditingController _recruitmentDriveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Societies')),
      body: Consumer<SocietyProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.societies.length,
            itemBuilder: (context, index) {
              final society = provider.societies[index];
              return ListTile(
                title: Text(society.name),
                subtitle: Text(society.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _nameController.text = society.name;
                        _descriptionController.text = society.description;
                        _upcomingEventController.text = society.upcomingEvent;
                        _recruitmentDriveController.text = society.recruitmentDrive;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit Society'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(labelText: 'Name'),
                                  ),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(labelText: 'Description'),
                                  ),
                                  TextField(
                                    controller: _upcomingEventController,
                                    decoration: InputDecoration(labelText: 'Upcoming Event (optional)'),
                                  ),
                                  TextField(
                                    controller: _recruitmentDriveController,
                                    decoration: InputDecoration(labelText: 'Recruitment Drive (optional)'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
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
                                  child: Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<SocietyProvider>(context, listen: false)
                            .deleteSociety(society.id);
                        _showSnackBar(context, 'Society deleted successfully');
                      },
                    ),
                  ],
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
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Society'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: _upcomingEventController,
                      decoration: InputDecoration(labelText: 'Upcoming Event (optional)'),
                    ),
                    TextField(
                      controller: _recruitmentDriveController,
                      decoration: InputDecoration(labelText: 'Recruitment Drive (optional)'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
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
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

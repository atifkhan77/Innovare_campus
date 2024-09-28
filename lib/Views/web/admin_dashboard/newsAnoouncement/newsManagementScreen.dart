import 'package:flutter/material.dart';
import 'package:innovare_campus/model/news.dart';
import 'package:innovare_campus/provider/newsProvider.dart';
import 'package:provider/provider.dart';

class NewsManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Management'),
      ),
      body: ListView.builder(
        itemCount: newsProvider.newsList.length,
        itemBuilder: (context, index) {
          final news = newsProvider.newsList[index];
          return ListTile(
            title: Text(news.title),
            subtitle: Text(news.content),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Update news functionality
                    _showEditNewsDialog(context, newsProvider, news);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    newsProvider.deleteNews(news.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add news functionality
          _showAddNewsDialog(context, newsProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNewsDialog(BuildContext context, NewsProvider newsProvider) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add News'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              // Additional fields like Image URL, Link, QR Code can be added here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newNews = NewsModel(
                  id: '', // ID will be assigned by Firestore
                  title: titleController.text,
                  content: contentController.text,
                  // Add other fields if necessary
                );
                newsProvider.addNews(newNews);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNewsDialog(
      BuildContext context, NewsProvider newsProvider, NewsModel news) {
    final titleController = TextEditingController(text: news.title);
    final contentController = TextEditingController(text: news.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit News'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              // Additional fields like Image URL, Link, QR Code can be added here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                news.title = titleController.text;
                news.content = contentController.text;
                // Update other fields if necessary
                newsProvider.updateNews(news);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

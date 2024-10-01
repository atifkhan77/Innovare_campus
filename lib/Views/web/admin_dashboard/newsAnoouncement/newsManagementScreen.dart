import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/web/Adminwidgets/drawers.dart';
import 'package:innovare_campus/model/news.dart';
import 'package:innovare_campus/provider/newsProvider.dart';
import 'package:provider/provider.dart';

class NewsManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Management',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: newsProvider.newsList.length,
          itemBuilder: (context, index) {
            final news = newsProvider.newsList[index];
            return _buildNewsCard(context, newsProvider, news);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNewsDialog(context, newsProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNewsCard(
      BuildContext context, NewsProvider newsProvider, NewsModel news) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              news.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
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
          ],
        ),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newNews = NewsModel(
                  id: '',
                  title: titleController.text,
                  content: contentController.text,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                news.title = titleController.text;
                news.content = contentController.text;

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

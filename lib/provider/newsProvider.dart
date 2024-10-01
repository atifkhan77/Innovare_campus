import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/news.dart';

class NewsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NewsModel> _newsList = [];

  List<NewsModel> get newsList => _newsList;

  NewsProvider() {
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final snapshot = await _firestore.collection('news').get();
      _newsList = snapshot.docs
          .map((doc) => NewsModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading news: $e');
    }
  }

  Future<void> addNews(NewsModel news) async {
    try {
      final docRef = await _firestore.collection('news').add(news.toMap());
      news.id = docRef.id;
      _newsList.add(news);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding news: $e');
    }
  }

  Future<void> updateNews(NewsModel news) async {
    try {
      await _firestore.collection('news').doc(news.id).update(news.toMap());
      final index = _newsList.indexWhere((n) => n.id == news.id);
      if (index != -1) {
        _newsList[index] = news;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating news: $e');
    }
  }

  Future<void> deleteNews(String id) async {
    try {
      await _firestore.collection('news').doc(id).delete();
      _newsList.removeWhere((news) => news.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting news: $e');
    }
  }
}

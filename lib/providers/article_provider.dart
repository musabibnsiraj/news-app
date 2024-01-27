import 'package:news_app/helpers/utill.dart';
import 'package:news_app/helpers/web_client.dart';
import 'package:news_app/models/article_model.dart';
import 'package:flutter/material.dart';
import '../../app_config.dart';

class ArticleProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final List<Article> _allArticles = [];
  List<Article> get getAllArticle => [..._allArticles];
  static const apiKey = AppConfig.apiKey;

  Future<void> getAllArticles({String? searchText, String? sortBy}) async {
    // Ensure that the method is not called during the build phase
    try {
      _isLoading = true;

      final res = await WebClient().get('everything', params: {
        if (searchText != null)
          'q': searchText, // Only include 'q' if searchText is not null
        'apiKey': apiKey,
        'language': 'en',
        'domains': 'bbc.co.uk',
        if (sortBy != null)
          'sortBy': sortBy, // Only include 'sortBy' if sortBy is not null
      });

      // Clear existing news before adding new ones
      _allArticles.clear();

      if (res != null && res['status'] == "ok") {
        // _totalResults = res['totalResults'] ?? 0;
        var articles = res['articles'] ?? [];
        for (var article in articles) {
          if (article['title'] != '[Removed]') {
            _allArticles.add(Article.fromJson(article));
          }
        }
      }
    } catch (e) {
      // If an error occurs during the process, show an error message
      Utill.showError("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after completing the operation (even if there's an error)
    }
  }

  Future<void> getTopHeadingsByCategory(
      {String? category, String? searchText}) async {
    // Ensure that the method is not called during the build phase
    try {
      _isLoading = true;
      final res = await WebClient().get('top-headlines', params: {
        'category': category,
        'apiKey': apiKey,
        'language': 'en',
        'domains': 'bbc.co.uk',
        if (searchText != null)
          'q': searchText, // Only include 'q' if searchText is not null
      });

      // Clear existing news before adding new ones
      _allArticles.clear();

      if (res != null && res['status'] == "ok") {
        // _totalResults = res['totalResults'] ?? 0;
        var articles = res['articles'] ?? [];
        for (var article in articles) {
          if (article['title'] != '[Removed]') {
            _allArticles.add(Article.fromJson(article));
          }
        }
      }
    } catch (e) {
      // If an error occurs during the process, show an error message
      Utill.showError("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after completing the operation (even if there's an error)
    }
  }
}

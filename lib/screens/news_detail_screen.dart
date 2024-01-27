import 'package:news_app/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:news_app/widgets/common_widget.dart';
import 'package:news_app/app_config.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Article Detail'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display article title
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            // Display article image (if available)
            if (article.urlToImage != null)
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  height: 200.0,
                  width: double.infinity,
                  Uri.parse(article.urlToImage!).isAbsolute
                      ? article.urlToImage!
                      : 'https://${article.urlToImage!}', // Add the correct scheme
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    // Handle the error by returning a placeholder image
                    return Image.network(
                      height: 200.0,
                      width: double.infinity,
                      AppConfig.noImage,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            // Display article content
            Text(
              article.content ?? '',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            // Display additional information about the article
            // For example, you might display the author, date, etc.
            Text(
              'Author: ${article.author ?? "Unknown"}',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Published At: ${article.publishedAt}',
              style: const TextStyle(fontSize: 16.0),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/article_model.dart';
import '../providers/favorites_provider.dart';
import 'favorites_screen.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final ArticleModel article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final favoritesNotifier = ref.read(favoritesListProvider.notifier);
    final isFav = ref.watch(favoritesListProvider).any(
            (element) => element.url.trim() == article.url.trim()
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
            onPressed: () {
              favoritesNotifier.toggleFavorite(article);

              final isNowFav = ref.read(favoritesListProvider).any((e) => e.url == article.url);

              if (isNowFav) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Saved to favorites!'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'VIEW',
                      textColor: Colors.yellow,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox(height: 200, child: Icon(Icons.broken_image, size: 100)),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (article.publishedAt != null)
                    Text(
                      'Published on: ${article.publishedAt!.split('T')[0]}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  const Divider(height: 30),

                  Text(
                    article.content ?? article.description ?? 'No content available.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
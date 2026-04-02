import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import 'article_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites saved yet.'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final article = favorites[index];
          return ListTile(
            leading: article.urlToImage != null
                ? Image.network(article.urlToImage!, width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.newspaper),
            title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.redAccent),
              onPressed: () {
                ref.read(favoritesListProvider.notifier).toggleFavorite(article);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Article removed from favorites'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => ArticleDetailScreen(article: article)),
            ),
          );
        },
      ),
    );
  }
}
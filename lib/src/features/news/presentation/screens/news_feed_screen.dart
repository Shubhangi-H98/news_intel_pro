import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';

class NewsFeedScreen extends ConsumerWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Intelligence', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
      ),
      body: newsAsync.when(
        data: (articles) => RefreshIndicator(
          onRefresh: () => ref.refresh(newsProvider.future),
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: article.urlToImage != null
                        ? Image.network(article.urlToImage!, width: 80, height: 80, fit: BoxFit.cover)
                        : const Icon(Icons.newspaper, size: 50),
                  ),
                  title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(article.description ?? '', maxLines: 2),
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('error: $err')),
      ),
    );
  }
}
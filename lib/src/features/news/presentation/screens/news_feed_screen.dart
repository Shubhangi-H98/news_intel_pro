import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../../data/models/article_model.dart';
import 'article_detail_screen.dart';
import 'search_screen.dart';

class NewsFeedScreen extends ConsumerWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu_outlined, color: Colors.blueAccent),
          onPressed: () {},
        ),
        title: const Text(
          'News',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.blueAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const SearchScreen())
              );
            },
          ),
        ],
      ),
      body: newsAsync.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text("No news available. Pull to refresh!"));
          }

          final featuredArticle = articles[0];
          final recentArticles = articles.length > 1 ? articles.sublist(1) : <ArticleModel>[];

          return RefreshIndicator(
            onRefresh: () => ref.refresh(newsProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeaturedCard(article: featuredArticle),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'RECENT',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: recentArticles.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final article = recentArticles[index];
                      return RecentArticleCard(article: article);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  final ArticleModel article;
  const FeaturedCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ArticleDetailScreen(article: article)));
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blueGrey.shade100,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            article.urlToImage != null
                ? Image.network(article.urlToImage!, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
                : const Icon(Icons.newspaper, size: 100),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                    child: const Text('TRENDING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class RecentArticleCard extends StatelessWidget {
  final ArticleModel article;
  const RecentArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ArticleDetailScreen(article: article)));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: article.urlToImage != null
                  ? Image.network(article.urlToImage!, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
                  : const Icon(Icons.newspaper, size: 50),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.publishedAt?.split('T')[0] ?? 'Today',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
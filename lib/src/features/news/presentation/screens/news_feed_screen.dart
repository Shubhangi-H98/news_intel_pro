import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../favorites/auth/presentation/screens/login_screen.dart';
import '../providers/favorites_provider.dart';
import '../providers/news_provider.dart';
import '../../data/models/article_model.dart';
import 'article_detail_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  ConsumerState<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends ConsumerState<NewsFeedScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  final List<String> categories = ['All', 'Business', 'Technology', 'Sports', 'Science', 'Health', 'Entertainment'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(newsPaginationProvider.notifier).fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout from News Intel Pro?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(authRepositoryProvider).logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                }
              },
              child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsPaginationProvider);
    final favorites = ref.watch(favoritesListProvider);
    final hasFavorites = favorites.isNotEmpty;

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
          'News Intel Pro',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blueAccent,
          tabs: categories.map((cat) => Tab(text: cat)).toList(),
          onTap: (index) {
            ref.read(currentCategoryProvider.notifier).state = categories[index].toLowerCase();
            ref.read(newsPaginationProvider.notifier).fetchInitial();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              hasFavorites ? Icons.bookmarks : Icons.bookmarks_outlined,
              color: hasFavorites ? Colors.redAccent : Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const SearchScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: newsAsync.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text("No news available. Pull to refresh!"));
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(newsPaginationProvider.notifier).fetchInitial(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: articles.length + 1,
              itemBuilder: (context, index) {
                if (index < articles.length) {
                  final article = articles[index];
                  if (index == 0) {
                    return FeaturedCard(article: article);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RecentArticleCard(article: article),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
                  );
                }
              },
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
      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (c) => ArticleDetailScreen(article: article))); },
      child: Container(
        height: 250, margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.blueGrey.shade100),
        clipBehavior: Clip.antiAlias,
        child: Stack(fit: StackFit.expand, children: [
          article.urlToImage != null ? Image.network(article.urlToImage!, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)) : const Icon(Icons.newspaper, size: 100),
          Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)), child: const Text('TRENDING', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              const SizedBox(height: 8),
              Text(article.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
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
      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (c) => ArticleDetailScreen(article: article))); },
      child: Container(
        height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          SizedBox(width: 100, child: article.urlToImage != null ? Image.network(article.urlToImage!, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)) : const Icon(Icons.newspaper, size: 50)),
          Expanded(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(article.publishedAt?.split('T')[0] ?? 'Today', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]))),
        ]),
      ),
    );
  }
}
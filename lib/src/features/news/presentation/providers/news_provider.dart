import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/news_repository.dart';
import '../../data/models/article_model.dart';

final newsRepositoryProvider = Provider((ref) => NewsRepository());

final currentCategoryProvider = StateProvider<String>((ref) => 'all');

class NewsNotifier extends StateNotifier<AsyncValue<List<ArticleModel>>> {
  final NewsRepository _repository;
  final Ref _ref;
  int _currentPage = 1;
  bool _isFetchingMore = false;

  NewsNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    final category = _ref.read(currentCategoryProvider);
    _currentPage = 1;
    state = const AsyncValue.loading();
    try {
      final news = await _repository.getNews(category: category, page: _currentPage);
      state = AsyncValue.data(news);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> fetchMore() async {
    if (_isFetchingMore || state.isLoading) return;
    _isFetchingMore = true;
    _currentPage++;
    final category = _ref.read(currentCategoryProvider);

    try {
      final moreNews = await _repository.getNews(category: category, page: _currentPage);
      if (moreNews.isNotEmpty) {
        final currentNews = state.value ?? [];
        state = AsyncValue.data([...currentNews, ...moreNews]);
      }
    } catch (e) {
      _currentPage--;
    } finally {
      _isFetchingMore = false;
    }
  }
}

final newsPaginationProvider = StateNotifierProvider<NewsNotifier, AsyncValue<List<ArticleModel>>>((ref) {
  return NewsNotifier(ref.read(newsRepositoryProvider), ref);
});

final searchQueryProvider = StateProvider<String>((ref) => "");

final searchNewsProvider = FutureProvider<List<ArticleModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final repository = ref.read(newsRepositoryProvider);

  if (query.isEmpty || query.length < 3) {
    return [];
  }

  await Future.delayed(const Duration(seconds: 1));

  return repository.searchNews(query);
});
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/news_repository.dart';
import '../../data/models/article_model.dart';

final newsRepositoryProvider = Provider((ref) => NewsRepository());

final newsProvider = FutureProvider<List<ArticleModel>>((ref) async {
  final repository = ref.read(newsRepositoryProvider);
  return repository.getBusinessNews();
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
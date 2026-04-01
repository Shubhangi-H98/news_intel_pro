import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/news_repository.dart';
import '../../data/models/article_model.dart';

final newsRepositoryProvider = Provider((ref) => NewsRepository());

final newsProvider = FutureProvider<List<ArticleModel>>((ref) async {
  final repository = ref.read(newsRepositoryProvider);
  return repository.getBusinessNews();
});
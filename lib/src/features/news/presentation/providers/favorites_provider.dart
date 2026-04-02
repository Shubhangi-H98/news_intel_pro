import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/article_model.dart';

final favoritesBoxProvider = Provider((ref) => Hive.box<ArticleModel>('favorites'));

final favoritesListProvider = StateNotifierProvider<FavoritesNotifier, List<ArticleModel>>((ref) {
  final box = ref.watch(favoritesBoxProvider);
  return FavoritesNotifier(box);
});

class FavoritesNotifier extends StateNotifier<List<ArticleModel>> {
  final Box<ArticleModel> _box;

  FavoritesNotifier(this._box) : super(_box.values.toList());

  void toggleFavorite(ArticleModel article) {
    if (_box.containsKey(article.url)) {
      _box.delete(article.url);
    } else {
      _box.put(article.url, article);
    }
    state = _box.values.toList();
  }

  bool isFavorite(String url) => _box.containsKey(url);
}
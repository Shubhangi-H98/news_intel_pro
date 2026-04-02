import 'package:hive/hive.dart';
import '../models/article_model.dart';

class FavoritesRepository {
  final Box<ArticleModel> _favoriteBox = Hive.box<ArticleModel>('favorites');

  void toggleFavorite(ArticleModel article) {
    if (_favoriteBox.containsKey(article.url)) {
      _favoriteBox.delete(article.url);
    } else {
      _favoriteBox.put(article.url, article);
    }
  }
  bool isFavorite(String url) => _favoriteBox.containsKey(url);

  List<ArticleModel> getAllFavorites() => _favoriteBox.values.toList();
}
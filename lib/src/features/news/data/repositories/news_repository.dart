import 'package:dio/dio.dart';
import '../models/article_model.dart';

class NewsRepository {
  final Dio _dio = Dio();

  final String _apiKey = 'a80e5d23ebf248709c4ee8f1f1b10471';

  Future<List<ArticleModel>> getBusinessNews() async {
    try {
      final response = await _dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'in',
          'category': 'business',
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List articlesJson = response.data['articles'];
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
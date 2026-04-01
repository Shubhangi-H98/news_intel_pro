import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../models/article_model.dart';

class NewsRepository {
  final Dio _dio = Dio();
  final String _apiKey = 'cc5e789726a94666a2dc7c49a06d2aa7';

  Future<List<ArticleModel>> getBusinessNews() async {
    try {
      debugPrint("---------- DEBUG: API CALL START ----------");

      final String url = 'https://newsapi.org/v2/top-headlines';
      final Map<String, dynamic> params = {
        'country': 'us',
        'category': 'business',
        'apiKey': _apiKey,
      };

      debugPrint("Request URL: $url");
      debugPrint("Request Params: $params");

      final response = await _dio.get(
        url,
        queryParameters: params,
      );

      debugPrint("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("Raw Data Received: ${response.data}");

        final List articlesJson = response.data['articles'] ?? [];
        debugPrint("Total Articles Found: ${articlesJson.length}");

        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        debugPrint("API Error Response: ${response.data}");
        throw Exception('Failed to load news');
      }
    } catch (e) {
      debugPrint("---------- DEBUG: API CALL FAILED ----------");
      debugPrint("Error Type: ${e.runtimeType}");
      debugPrint("Error Detail: $e");

      if (e is DioException) {
        debugPrint("Dio Error Message: ${e.message}");
        debugPrint("Dio Error Response: ${e.response?.data}");
      }

      throw Exception('Error fetching news: $e');
    }
  }

  Future<List<ArticleModel>> searchNews(String query) async {
    try {
      debugPrint("---------- DEBUG: SEARCH CALL START ----------");

      final String url = 'https://newsapi.org/v2/everything';
      final Map<String, dynamic> params = {
        'qInTitle': '"$query"',
        'sortBy': 'relevancy',
        'language': 'en',
        'apiKey': _apiKey,
      };

      debugPrint("Search URL: $url");
      debugPrint("Search Query: $query");

      final response = await _dio.get(url, queryParameters: params);

      debugPrint("Search Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List articlesJson = response.data['articles'] ?? [];
        debugPrint("Total Search Results: ${articlesJson.length}");
        return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      debugPrint("---------- DEBUG: SEARCH FAILED ----------");
      if (e is DioException) {
        debugPrint("Dio Error: ${e.response?.data}");
      }
      throw Exception('Error searching news: $e');
    }
  }
}
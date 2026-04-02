import 'package:hive/hive.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final String? urlToImage;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String? content;

  @HiveField(5)
  final String? publishedAt;

  ArticleModel({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    this.content,
    this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
      content: json['content'],
      publishedAt: json['publishedAt'],
    );
  }
}
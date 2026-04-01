class ArticleModel {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;
  final String? content;
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
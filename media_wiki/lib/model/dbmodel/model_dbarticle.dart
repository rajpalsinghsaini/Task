// Article table name
const String tableArticle = 'article';

// This class defines article table fields
class ArticleFields {
  static const String id = '_id';
  static const String articleTitle = 'title';
  static const String articleDesc = "description";

  static final List<String> values = [id, articleTitle, articleDesc];
}

// Model class for article table
class Article {
  final int? id;
  final String title;
  final String description;

  Article({this.id, required this.title, required this.description});

  Map<String, Object?> toJson() => {
        ArticleFields.id: id,
        ArticleFields.articleTitle: title,
        ArticleFields.articleDesc: description
      };

  static Article fromJson(Map<String, Object?> json) => Article(
      id: json[ArticleFields.id] as int?,
      title: json[ArticleFields.articleTitle] as String,
      description: json[ArticleFields.articleDesc] as String);

  Article copy({int? id}) =>
      Article(id: id ?? this.id, title: title, description: description);
}

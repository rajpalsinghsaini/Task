import 'package:flutter/material.dart';
import 'package:media_wiki/api/wiki_api.dart';
import 'package:media_wiki/db/wiki_database.dart';
import 'package:media_wiki/model/article_model.dart';
import 'package:media_wiki/model/dbmodel/model_dbarticle.dart';

class ArticleProviderFile extends ChangeNotifier {
  final List<String> _articlesSnapshot = [];
  final List<String> _articleTitle = [];
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingArticles = false;
  String nextArticleValue = '3089277|Confusion_of_Tongues.png';

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<String> get articles => _articlesSnapshot;

  List<String> get titles => _articleTitle;

  Future fetchNextArticles() async {
    if (_isFetchingArticles) return;

    _errorMessage = '';
    _isFetchingArticles = true;

    try {
      final snap = await WikiApi.getRandomArticle(nextArticleValue);
      _articlesSnapshot.addAll(snap!.articleList);
      _articleTitle.addAll(snap.articleTitle);
      //nextArticleValue = snap.continueVal;

      insertArticleInDatabase(snap);

      if (snap.articleList.isEmpty) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingArticles = false;
  }

  // Method to insert article in database
  void insertArticleInDatabase(ArticleModel snap) async {
    if (snap.articleTitle.isNotEmpty) {
      for (int i = 0; i < snap.articleTitle.length; i++) {
        bool isArticleExist =
            await WikiDatabase.instance.readArticle(snap.articleTitle[i]);
        if (!isArticleExist) {
          Article article = Article(
              title: snap.articleTitle[i], description: snap.articleList[i]);
          await WikiDatabase.instance.createArticle(article);
        }
      }
    }
  }
}

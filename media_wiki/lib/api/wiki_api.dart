import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:media_wiki/model/article_model.dart';
import 'package:media_wiki/model/category_model.dart';
import 'package:media_wiki/model/image_model.dart';

class WikiApi {
  static const String _imageBaseUrl =
      "https://commons.wikimedia.org/w/api.php?action=query&prop=imageinfo&iiprop=timestamp%7Cuser%7Curl&generator=categorymembers&gcmtype=file&gcmtitle=Category:Featured_pictures_on_Wikimedia_Commons&format=json&utf8";

  static const String _articleUrl =
      "https://en.wikipedia.org/w/api.php?format=json&action=query&generator=random&grnnamespace=0&prop=revisions%7Cimages&rvprop=content&grnlimit=10";

  static const String _categoryUrl =
      "https://en.wikipedia.org/w/api.php?action=query&list=allcategories&acprefix=List%20of&formatversion=2&format=json";

  // This method fetch image data from the server
  static Future<ImageModel?> getImageDetails(String nextValue) async {
    final response =
        await http.get(Uri.parse(_imageBaseUrl + "&gcmcontinue=" + nextValue));
    List<String> pageIdList = [];
    List<String> imageUrl = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = json.decode(response.body);

      var continueVal = myMap['continue']['gcmcontinue'];

      var value = myMap['query']['pages'];
      Map<String, dynamic> data = Map<String, dynamic>.from(value);

      for (var imageKeys in data.keys) {
        pageIdList.add(imageKeys);
      }

      for (var imgIndex in pageIdList) {
        imageUrl.add(myMap['query']['pages'][imgIndex]['imageinfo'][0]['url']);
      }

      ImageModel imageModel = ImageModel(
          continueVal: continueVal, urlString: imageUrl, pageId: pageIdList);
      return imageModel;
    } else {
      return null;
    }
  }

  // This method fetch random article list from server
  static Future<ArticleModel?> getRandomArticle(String nextValue) async {
    List<String> pageIdList = [];
    List<String> articleList = [];
    List<String> articleTitleList = [];

    final response =
        await http.get(Uri.parse(_articleUrl + "&imcontinue=" + nextValue));

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = json.decode(response.body);
      var continueVal = myMap['continue']['imcontinue'];

      var value = myMap['query']['pages'];
      Map<String, dynamic> data = Map<String, dynamic>.from(value);

      for (var imageKeys in data.keys) {
        pageIdList.add(imageKeys);
      }

      for (var articleIndex in pageIdList) {
        articleList
            .add(myMap['query']['pages'][articleIndex]['revisions'][0]['*']);
        articleTitleList.add(myMap['query']['pages'][articleIndex]['title']);
      }
      ArticleModel articleModel = ArticleModel(
          continueVal: continueVal,
          articleList: articleList,
          articleTitle: articleTitleList,
          pageId: pageIdList);


      return articleModel;
    } else {
      return null;
    }
  }

  // This method fetch all categories from server
  static Future<CategoryModel?> getAllCategories(String nextValue) async {
    List<String> categoryList = [];

    final response =
        await http.get(Uri.parse(_categoryUrl + "&accontinue=" + nextValue));

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = json.decode(response.body);
      var continueVal = myMap['continue']['accontinue'];

      var value = myMap['query']['allcategories'];

      for (int i = 0; i < value.length; i++) {
        categoryList.add(value[i]['category']);
      }

      CategoryModel categoryModel =
          CategoryModel(continueVal: continueVal, categoryList: categoryList);

      return categoryModel;
    } else {
      return null;
    }
  }
}

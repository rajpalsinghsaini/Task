import 'package:flutter/material.dart';
import 'package:media_wiki/api/wiki_api.dart';
import 'package:media_wiki/db/wiki_database.dart';
import 'package:media_wiki/model/category_model.dart';
import 'package:media_wiki/model/dbmodel/model_dbcategory.dart';

class CategoryProviderFile extends ChangeNotifier {
  final List<String> _categoriesSnapshot = [];
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingCategories = false;
  String nextCategoryValue = '';

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<String> get categories => _categoriesSnapshot;

  Future fetchNextCategories() async {
    if (_isFetchingCategories) return;

    _errorMessage = '';
    _isFetchingCategories = true;

    try {
      final snap = await WikiApi.getAllCategories(nextCategoryValue);
      _categoriesSnapshot.addAll(snap!.categoryList);
      nextCategoryValue = snap.continueVal;

      insertCategoriesInDb(snap);

      if (snap.categoryList.isEmpty) _hasNext = false;

      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingCategories = false;
  }

  // This method insert category names in database
  void insertCategoriesInDb(CategoryModel snap) async {
    if (snap.categoryList.isNotEmpty) {
      for (int i = 0; i < snap.categoryList.length; i++) {
        bool isCategoryExist =
            await WikiDatabase.instance.readCategory(snap.categoryList[i]);
        if (!isCategoryExist) {
          Category category = Category(catname: snap.categoryList[i]);
          await WikiDatabase.instance.createCategory(category);
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:media_wiki/api/wiki_api.dart';
import 'package:media_wiki/db/wiki_database.dart';
import 'package:media_wiki/model/dbmodel/model_dbimages.dart';

class ImageProviderFile extends ChangeNotifier {
  final List<String> _imagesSnapshot = [];
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingImages = false;
  String nextImageValue = '0';

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<String> get images => _imagesSnapshot;

  Future fetchNextImages() async {
    if (_isFetchingImages) return;

    _errorMessage = '';
    _isFetchingImages = true;

    try {
      final snap = await WikiApi.getImageDetails(nextImageValue);
      _imagesSnapshot.addAll(snap!.urlString);
      nextImageValue = snap.continueVal;

      insertImagesInDb(_imagesSnapshot);

      if (snap.urlString.isEmpty) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingImages = false;
  }

  // This method insert category names in database
  void insertImagesInDb(List<String> imagesSnapshot) async {
    if (imagesSnapshot.isNotEmpty) {
      for (int i = 0; i < imagesSnapshot.length; i++) {
        bool isImageExist =
            await WikiDatabase.instance.readSingleImage(imagesSnapshot[i]);
        if (!isImageExist) {
          WImage wImage = WImage(imgurl: imagesSnapshot[i]);
          await WikiDatabase.instance.createImage(wImage);
        }
      }
    }
  }
}

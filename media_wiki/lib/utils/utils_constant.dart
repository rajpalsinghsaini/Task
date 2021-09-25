import 'dart:io';

import 'package:flutter/material.dart';

// This class defines the utils constant
class UtilsConstant {
  // Constants for strings
  static const textLoading = "Loading Please wait...";
  static const textTitle = "Title : ";
  static const textReadFullArticle = "Click to read full article";
  static const textShowLess = "show less";
  static const textDarkMode = "Dark Mode";
  static const textSettings = "Settings";
  static const textSettingsPage = "Settings Page";
  static const textName = "Rajpal Singh";
  static const textEmail = "enggrapal@gmail.com";
  static const textImages = "Images";
  static const textArticles = "Articles";
  static const textCategories = "Categories";
  static const textTitleMainPage = "Main Page";

  // This method checks internet connection is available or not
  static Future<bool> checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      const snackBar = SnackBar(content: Text('No Internet Connection'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return false;
  }

  // Method to show CustomDialog
  static void showReadArticleDialog(BuildContext context,
      String title,
      String articles,) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 8,
            insetPadding: const EdgeInsets.all(18),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          color: Colors.green),
                    ),
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Text(
                          articles,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:media_wiki/provider/article_provider.dart';
import 'package:media_wiki/utils/utils_constant.dart';
import 'package:media_wiki/widget/listview_article_widget.dart';
import 'package:media_wiki/widget/offline/offline_article_widget.dart';
import 'package:provider/provider.dart';

class ArticleTab extends StatefulWidget {
  const ArticleTab({Key? key}) : super(key: key);

  @override
  _ArticleTab createState() => _ArticleTab();
}

class _ArticleTab extends State<ArticleTab> {

  bool isInternetAvailable = false;
  late Widget widgetValue;

  @override
  void initState() {
    super.initState();

    InternetConnectionChecker().onStatusChange.listen((status) {

      final hasInternet = status == InternetConnectionStatus.connected;

      setState(() {

        isInternetAvailable = hasInternet;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UtilsConstant.checkInternetConnection(context),
      // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text(UtilsConstant.textLoading));
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            bool? value = snapshot.data;
            if (value != null) {
              !value
                  ? widgetValue = const OfflineArticleWidget()
                  : widgetValue = ChangeNotifierProvider(
                create: (context) => ArticleProviderFile(),
                child: Scaffold(
                  body: Consumer<ArticleProviderFile>(
                    builder: (context, articlesProvider, _) => ArticleListViewWidget(
                      articlesProvider: articlesProvider,
                    ),
                  ),
                ),
              );
            }
            return widgetValue;
          }
        }
      },
    );
  }
}

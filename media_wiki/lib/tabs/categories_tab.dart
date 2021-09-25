import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:media_wiki/provider/category_provider.dart';
import 'package:media_wiki/utils/utils_constant.dart';
import 'package:media_wiki/widget/listview_category_widget.dart';
import 'package:media_wiki/widget/offline/offline_category_widget.dart';
import 'package:provider/provider.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({Key? key}) : super(key: key);

  @override
  _CategoriesTab createState() => _CategoriesTab();
}

class _CategoriesTab extends State<CategoriesTab> {
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
                  ? widgetValue = const OfflineCategoryWidget()
                  : widgetValue = ChangeNotifierProvider(
                      create: (context) => CategoryProviderFile(),
                      child: Scaffold(
                        body: Consumer<CategoryProviderFile>(
                          builder: (context, categoriesProvider, _) =>
                              CategoryListViewWidget(
                            categoriesProvider: categoriesProvider,
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

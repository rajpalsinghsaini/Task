import 'package:flutter/material.dart';
import 'package:media_wiki/provider/theme_provider.dart';
import 'package:media_wiki/tabs/article_tab.dart';
import 'package:media_wiki/tabs/categories_tab.dart';
import 'package:media_wiki/tabs/image_tab.dart';
import 'package:media_wiki/utils/utils_constant.dart';
import 'package:media_wiki/widget/navigation_drawer_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Wiki App',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          darkTheme: MyThemes.darkTheme,
          theme: MyThemes.lightTheme,
          home: const MyHomePage(title: UtilsConstant.textTitleMainPage),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: AppBar(
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: [
                Tab(text: UtilsConstant.textImages),
                Tab(text: UtilsConstant.textArticles),
                Tab(text: UtilsConstant.textCategories),
              ],
            ),
          ),
          body: const TabBarView(
            children: [ImageTab(), ArticleTab(), CategoriesTab()],
          )),
    );
  }
}

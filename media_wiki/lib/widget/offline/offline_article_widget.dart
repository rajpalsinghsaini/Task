import 'package:flutter/material.dart';
import 'package:media_wiki/db/wiki_database.dart';
import 'package:media_wiki/model/dbmodel/model_dbarticle.dart';
import 'package:media_wiki/utils/utils_constant.dart';

class OfflineArticleWidget extends StatefulWidget {
  const OfflineArticleWidget({Key? key}) : super(key: key);

  @override
  _OfflineArticleWidget createState() => _OfflineArticleWidget();
}

class _OfflineArticleWidget extends State<OfflineArticleWidget> {
  List<Article> listArticle = [];

  @override
  void initState() {
    super.initState();
    loadArticlesFromDatabase();
  }

  // This method get all the save categories from database
  void loadArticlesFromDatabase() {
    WikiDatabase.instance.readAllArticles().then((value) {
      listArticle = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return listArticle.isEmpty
        ? const Center(
            child: Text(
            "No Articles Found",
            style: TextStyle(
                fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
          ))
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            physics: const BouncingScrollPhysics(),
            itemCount: listArticle.length,
            itemBuilder: (context, index) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 8,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Title : " + listArticle[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                title: TextButton(
                                  onPressed: () {
                                    UtilsConstant.showReadArticleDialog(
                                        context,
                                        listArticle[index].title,
                                        listArticle[index].description);
                                  },
                                  child: const Text(
                                      UtilsConstant.textReadFullArticle),
                                ),
                              )
                            ],
                          )),
                    ),
                  ));
            });
  }
}

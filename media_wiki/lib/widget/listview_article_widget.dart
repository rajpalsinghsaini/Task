import 'package:flutter/material.dart';
import 'package:media_wiki/provider/article_provider.dart';
import 'package:media_wiki/utils/utils_constant.dart';

class ArticleListViewWidget extends StatefulWidget {
  final ArticleProviderFile articlesProvider;

  const ArticleListViewWidget({Key? key, required this.articlesProvider})
      : super(key: key);

  @override
  _ArticleListViewWidget createState() => _ArticleListViewWidget();
}

class _ArticleListViewWidget extends State<ArticleListViewWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    widget.articlesProvider.fetchNextArticles();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.articlesProvider.hasNext) {
        widget.articlesProvider.fetchNextArticles();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        children: [
          ...widget.articlesProvider.articles
              .asMap()
              .map((i, articles) => MapEntry(
                  i,
                  Card(
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
                                  UtilsConstant.textTitle +
                                      widget.articlesProvider.titles[i],
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
                                        widget.articlesProvider.titles[i],
                                        articles);
                                  },
                                  child: const Text(
                                      UtilsConstant.textReadFullArticle),
                                ),
                              )
                            ],
                          )),
                    ),
                  )))
              .values
              .toList(),
          if (widget.articlesProvider.hasNext)
            Center(
              child: GestureDetector(
                onTap: widget.articlesProvider.fetchNextArticles,
                child: const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      );
}

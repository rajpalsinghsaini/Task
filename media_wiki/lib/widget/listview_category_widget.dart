import 'package:flutter/material.dart';
import 'package:media_wiki/provider/category_provider.dart';

class CategoryListViewWidget extends StatefulWidget {
  final CategoryProviderFile categoriesProvider;

  const CategoryListViewWidget({Key? key, required this.categoriesProvider})
      : super(key: key);

  @override
  _CategoryListViewWidget createState() => _CategoryListViewWidget();
}

class _CategoryListViewWidget extends State<CategoryListViewWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    widget.categoriesProvider.fetchNextCategories();
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
      if (widget.categoriesProvider.hasNext) {
        widget.categoriesProvider.fetchNextCategories();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        children: [
          ...widget.categoriesProvider.categories
              .asMap()
              .map((i, categories) => MapEntry(
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
                                  categories,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )),
                    ),
                  )))
              .values
              .toList(),
          if (widget.categoriesProvider.hasNext)
            Center(
              child: GestureDetector(
                onTap: widget.categoriesProvider.fetchNextCategories,
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

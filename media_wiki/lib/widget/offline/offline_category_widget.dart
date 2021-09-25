import 'package:flutter/material.dart';
import 'package:media_wiki/db/wiki_database.dart';
import 'package:media_wiki/model/dbmodel/model_dbcategory.dart';

class OfflineCategoryWidget extends StatefulWidget {
  const OfflineCategoryWidget({Key? key}) : super(key: key);

  @override
  _OfflineCategoryWidget createState() => _OfflineCategoryWidget();
}

class _OfflineCategoryWidget extends State<OfflineCategoryWidget> {
  List<Category> listCategory = [];

  @override
  void initState() {
    super.initState();
    loadCategoriesFromDatabase();
  }

  // This method get all the save categories from database
  void loadCategoriesFromDatabase() {
    WikiDatabase.instance.readAllCategories().then((value) {
      listCategory = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return listCategory.isEmpty
        ? const Center(
            child: Text(
            "No Categories Found",
            style: TextStyle(
                fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
          ))
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            physics: const BouncingScrollPhysics(),
            itemCount: listCategory.length,
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
                                  listCategory[index].catname,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ));
            });
  }
}

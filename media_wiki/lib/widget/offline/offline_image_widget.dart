import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_wiki/db/wiki_database.dart';
import 'package:media_wiki/model/dbmodel/model_dbimages.dart';

class OfflineImageWidget extends StatefulWidget {
  const OfflineImageWidget({Key? key}) : super(key: key);

  @override
  _OfflineImageWidget createState() => _OfflineImageWidget();
}

class _OfflineImageWidget extends State<OfflineImageWidget> {
  List<WImage> listImages = [];

  @override
  void initState() {
    super.initState();
    loadImagesFromDatabase();
  }

  // This method get all the save categories from database
  void loadImagesFromDatabase() async {
    WikiDatabase.instance.readAllImages().then((value) {
      listImages = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => listImages.isEmpty
      ? const Center(
          child: Text(
          "No Images Found",
          style: TextStyle(
              fontSize: 25, color: Colors.red, fontWeight: FontWeight.bold),
        ))
      : CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (c, i) => createImageGrid(listImages[i].imgurl),
                childCount: listImages.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            ),
          ],
        );

  Widget createImageGrid(String url) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                key: UniqueKey(),
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                imageUrl: url,
                maxHeightDiskCache: 75,
                placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(50),
                    child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )),
      ),
    );
  }
}

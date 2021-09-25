
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_wiki/provider/image_provider.dart';

class ImageListViewWidget extends StatefulWidget {
  final ImageProviderFile imagesProvider;

  const ImageListViewWidget({
    Key? key,
    required this.imagesProvider,
  }) : super(key: key);

  @override
  _ImageListViewWidgetState createState() => _ImageListViewWidgetState();
}

class _ImageListViewWidgetState extends State<ImageListViewWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    widget.imagesProvider.fetchNextImages();

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
      if (widget.imagesProvider.hasNext) {
        widget.imagesProvider.fetchNextImages();
      }
    }
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (c, i) => createImageGrid(widget.imagesProvider.images[i]),
              childCount: widget.imagesProvider.images.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          ),
          if (widget.imagesProvider.hasNext)
            SliverToBoxAdapter(
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: widget.imagesProvider.fetchNextImages,
                  child: const CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      );

  Widget createImageGrid(String url) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 10, 0, 0),
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
    );
  }

}

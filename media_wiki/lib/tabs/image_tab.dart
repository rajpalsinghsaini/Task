
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:media_wiki/provider/image_provider.dart';
import 'package:media_wiki/utils/utils_constant.dart';
import 'package:media_wiki/widget/listview_image_widget.dart';
import 'package:media_wiki/widget/offline/offline_image_widget.dart';
import 'package:provider/provider.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({Key? key}) : super(key: key);

  @override
  _ImageTab createState() => _ImageTab();
}

class _ImageTab extends State<ImageTab> {
  bool isInternetAvailable = false;
  late Widget widgetValue;


  @override
  initState() {
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
                  ? widgetValue = const OfflineImageWidget()
                  : widgetValue = ChangeNotifierProvider(
                      create: (context) => ImageProviderFile(),
                      child: Scaffold(
                        body: Consumer<ImageProviderFile>(
                          builder: (context, imagesProvider, _) =>
                              ImageListViewWidget(
                            imagesProvider: imagesProvider,
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

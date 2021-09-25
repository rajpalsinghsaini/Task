import 'package:flutter/material.dart';
import 'package:media_wiki/utils/utils_constant.dart';
import 'package:media_wiki/widget/change_theme_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UtilsConstant.textSettingsPage),
        centerTitle: true,
      ),
      body: const ChangeThemeWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:media_wiki/provider/theme_provider.dart';
import 'package:media_wiki/utils/utils_constant.dart';
import 'package:provider/provider.dart';

class ChangeThemeWidget extends StatefulWidget {
  const ChangeThemeWidget({Key? key}) : super(key: key);

  @override
  _ChangeThemeWidget createState() => _ChangeThemeWidget();
}

class _ChangeThemeWidget extends State<ChangeThemeWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            UtilsConstant.textDarkMode,
            style: TextStyle(fontSize: 20),
          ),
          Switch.adaptive(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(value);
              })
        ],
      ),
    );
  }
}

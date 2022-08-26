import 'package:flutter/material.dart';
import 'package:oas_mobile/flutx/widgets/button/button.dart';
import 'package:oas_mobile/flutx/widgets/text/text.dart';
import 'package:oas_mobile/flutx/themes/app_theme.dart';

class OasAppBar extends StatelessWidget with PreferredSizeWidget {
  OasAppBar(
      {Key? key,
      this.title,
      this.titleWidget,
      this.withLogo = false,
      this.actions,
      this.logoutFunc})
      : super(key: key);

  @override
  final Size preferredSize = new Size.fromHeight(35.0);

  final String? title;
  Widget? titleWidget;
  final bool withLogo;
  List<Widget>? actions;
  final VoidCallback? logoutFunc;

  @override
  Widget build(BuildContext context) {
    if (logoutFunc != null) {
      actions ??= [];
      actions!.add(IconButton(
        onPressed: logoutFunc,
        icon: Icon(Icons.logout),
        tooltip: 'Logout',
      ));
    }

    // invert the white text png
    titleWidget ??= ColorFiltered(
        colorFilter: ColorFilter.matrix(<double>[
          //R  G   B    A  Const
          1, 0, 0, 0, 255, //
          0, 1, 0, 0, 255, //
          0, 0, 1, 0, 255, //
          0, 0, 0, 1, 0, //
        ]),
        child: Image.asset('assets/images/OpenArtSource_white_text_only.png',
            height: 20));

    final Widget? theTitle = title == null ? titleWidget : FxText.sh1(title!);


    final Widget? theIcon = withLogo ? Padding(
      padding: EdgeInsets.only(left: 12),
      child: ColorFiltered(
          colorFilter: ColorFilter.matrix(<double>[
            0.2126,0.7152,0.0722,0,0,
            0.2126,0.7152,0.0722,0,0,
            0.2126,0.7152,0.0722,0,0,
            0,0,0,1,0,
          ]),
          child: Image.asset('assets/images/oas_icon.png')
      ),
    ) : null;


    //final Widget? theIcon =
    //    withLogo ? Image.asset('assets/images/oas_icon.png', height: 15) : null;

    return AppBar(
      leading: theIcon,
      title: theTitle,
      actions: actions,
      elevation: 4.0,
    );
  }
}

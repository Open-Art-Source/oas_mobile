import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PhotosActionGridViewWidget extends StatefulWidget {

  final List<Widget> images;

  const PhotosActionGridViewWidget({Key? key, required this.images}) : super(key: key);

  @override
  _PhotosActionGridViewWidgetState createState() =>
      _PhotosActionGridViewWidgetState();
}

class TextIconItem {
  String text;
  IconData iconData;

  TextIconItem(this.text, this.iconData);
}

class _PhotosActionGridViewWidgetState
    extends State<PhotosActionGridViewWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late ThemeData themeData;

  List<TextIconItem> _textIconChoice = [
    TextIconItem("View", MdiIcons.imageOutline),
    TextIconItem("Share", MdiIcons.shareOutline),
    TextIconItem("Delete", MdiIcons.deleteOutline),
    TextIconItem("Info", MdiIcons.informationOutline),
  ];

  List<Widget> _generateGridItems() {

    return widget.images.map( (image) =>

        Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: image,
              ),


/*          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Color(0xaa000000)),
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Item " + i.toString(),
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle1,
                            fontWeight: 500,
                            color: Colors.white)),
                    Container(
                      height: 16,
                      width: 16,
                      child: PopupMenuButton(
                        padding: EdgeInsets.all(0),
                        itemBuilder: (BuildContext context) {
                          return _textIconChoice.map((TextIconItem choice) {
                            return PopupMenuItem(
                              height: 36,
                              value: choice,
                              child: Row(
                                children: <Widget>[
                                  Icon(choice.iconData,
                                      size: 20,
                                      color:
                                          themeData.colorScheme.onBackground),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, bottom: 0),
                                    child: Text(choice.text,
                                        style: AppTheme.getTextStyle(
                                            themeData.textTheme.button,
                                            fontWeight: 600)),
                                  )
                                ],
                              ),
                            );
                          }).toList();
                        },
                        onSelected: (textIconItem) {
                          showSimpleSnackbar(textIconItem.text + " clicked");
                        },
                        icon: Icon(
                          MdiIcons.dotsVertical,
                          size: 18,
                        ),
                        color: themeData.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ))*/
          ],
        )).toList();


    /*
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image.asset(
              _imageList[i],
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),

         Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    color: Color(0xaa000000)),
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Item " + i.toString(),
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle1,
                            fontWeight: 500,
                            color: Colors.white)),
                    Container(
                      height: 16,
                      width: 16,
                      child: PopupMenuButton(
                        padding: EdgeInsets.all(0),
                        itemBuilder: (BuildContext context) {
                          return _textIconChoice.map((TextIconItem choice) {
                            return PopupMenuItem(
                              height: 36,
                              value: choice,
                              child: Row(
                                children: <Widget>[
                                  Icon(choice.iconData,
                                      size: 20,
                                      color:
                                          themeData.colorScheme.onBackground),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, bottom: 0),
                                    child: Text(choice.text,
                                        style: AppTheme.getTextStyle(
                                            themeData.textTheme.button,
                                            fontWeight: 600)),
                                  )
                                ],
                              ),
                            );
                          }).toList();
                        },
                        onSelected: (textIconItem) {
                          showSimpleSnackbar(textIconItem.text + " clicked");
                        },
                        icon: Icon(
                          MdiIcons.dotsVertical,
                          size: 18,
                        ),
                        color: themeData.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ));
    }
    return list;
    */
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
        color: themeData.backgroundColor,
        child: GridView.count(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 11,
            crossAxisSpacing: 11,
            children: _generateGridItems()));
  }

  void showSimpleSnackbar(String message) {
    _scaffoldKey.currentState?.showSnackBar(
      new SnackBar(
        duration: Duration(milliseconds: 1000),
        content: new Text(
          message,
          style: themeData.textTheme.subtitle2?.merge(TextStyle(color: themeData.colorScheme.onPrimary)),
        ),
        backgroundColor: themeData.colorScheme.primary,
      ),
    );
  }
}

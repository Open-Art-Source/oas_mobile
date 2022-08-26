import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oas_mobile/app/artist/empty_content.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';
import 'package:oas_mobile/app/market/market_store.dart';
import 'package:oas_mobile/app/sign_in/logout.dart';
import 'package:oas_mobile/flutx/utils/size_config.dart';
import 'package:oas_mobile/flutx/themes/app_theme.dart';
import 'package:oas_mobile/flutx/themes/app_theme_notifier.dart';
import 'package:provider/provider.dart';
import 'market_list_tile.dart';

class MarketPage extends StatefulWidget {
  //final BuildContext rootContext;

  //const MarketPage({Key? key, required this.rootContext}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> with Logout {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ThemeData themeData;

  double findAspectRatio(double width) {
    //Logic for aspect ratio of grid view
    return (width / 2 - MySize.size24!) / ((width / 2 - MySize.size24!) + 72);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: OasAppBar(
        logoutFunc: () => confirmSignOut(context),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    MarketStore store = Provider.of<MarketStore>(context, listen: false);
    return Observer(builder: (_) {
      if (store.readyListings.isEmpty) {
        return EmptyContent(message: 'Coming soon.',);
      }
      return Center(
        child: Consumer<FxAppThemeNotifier>(
          builder: (BuildContext context,
              FxAppThemeNotifier value,
              Widget? child,) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: FxAppTheme.getThemeFromThemeMode(),
              home: //SafeArea(
                //child:
                Scaffold(
                  resizeToAvoidBottomInset: false,
                  key: _scaffoldKey,
                  backgroundColor: themeData.backgroundColor,
                  /*
                // open panel by filter button
                  endDrawer: _EndDrawer(
                    scaffoldKey: _scaffoldKey,
                  ),
                  */
                  body:
                  /*
                // search, filter, sort row. maybe needed in future
                      Padding(
                          padding: EdgeInsets.all(MySize.size16!),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      letterSpacing: 0,
                                      fontWeight: 500),
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: AppTheme.getTextStyle(
                                        themeData.textTheme.subtitle2,
                                        letterSpacing: 0,
                                        fontWeight: 500),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MySize.size16!),
                                        ),
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MySize.size16!),
                                        ),
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MySize.size16!),
                                        ),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: themeData.colorScheme.background,
                                    prefixIcon: Icon(
                                      MdiIcons.magnify,
                                      size: MySize.size22,
                                      color: themeData.colorScheme.onBackground
                                          .withAlpha(150),
                                    ),
                                    isDense: true,
                                    contentPadding:
                                    EdgeInsets.only(right: MySize.size16!),
                                  ),
                                  textCapitalization:
                                  TextCapitalization.sentences,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext buildContext) {
                                        return SortBottomSheet();
                                      });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: MySize.size16!),
                                  decoration: BoxDecoration(
                                    color: themeData.backgroundColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(MySize.size16!)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeData.cardTheme.shadowColor!
                                            .withAlpha(48),
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.all(MySize.size12!),
                                  child: Icon(
                                    MdiIcons.swapVertical,
                                    color: themeData.colorScheme.primary,
                                    size: 22,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _scaffoldKey.currentState!.openEndDrawer();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: MySize.size16!),
                                  decoration: BoxDecoration(
                                    color: themeData.backgroundColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(MySize.size16!)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeData.cardTheme.shadowColor!
                                            .withAlpha(48),
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.all(MySize.size12!),
                                  child: Icon(
                                    MdiIcons.tune,
                                    color: themeData.colorScheme.primary,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.only(left: MySize.size16!, top: 0),
                        child: Text("Result for \"Cosmetics\"",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                fontWeight: 600)),
                      ),
                       */
                  ListView.separated(
                    padding: EdgeInsets.all(MySize.size8!),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: store.readyListings.length,
                    separatorBuilder: (context, index) => Divider(height: MySize.size16!),
                    itemBuilder: (context, index) {
                      return MarketListTile(
                        marketListing: store.readyListings[index],
                      );
                    },
                  ),
                ),
              //),
            );
          },
        ),
      );
    });
  }

}



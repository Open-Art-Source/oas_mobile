import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oas_mobile/app/artist/empty_content.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';
import 'package:oas_mobile/app/models/purchaseListing.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/app/sign_in/logout.dart';
import 'package:oas_mobile/flutx/utils/size_config.dart';
import 'package:oas_mobile/flutx/themes/app_theme.dart';
import 'package:oas_mobile/flutx/themes/app_theme_notifier.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import 'collection_list_tile.dart';
import 'collection_store.dart';

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> with Logout {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ThemeData themeData;

  double findAspectRatio(double width) {
    return (width / 2 - MySize.size24!) / ((width / 2 - MySize.size24!) + 72);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: OasAppBar(
        title: 'My Collection',
        logoutFunc: () => confirmSignOut(context),
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        //mini: true,
        onPressed: () => reLoad(),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    CollectionStore store =
        Provider.of<CollectionStore>(context, listen: false);
    return Observer(builder: (_) {
      if (store.allListings.isEmpty) {
        return EmptyContent(
          title: 'You don\'t have any collection yet',
          message: 'Explore our Market to fill up your collection.',
        );
      }
      return Center(
        child: Consumer<FxAppThemeNotifier>(
          builder: (
            BuildContext context,
            FxAppThemeNotifier value,
            Widget? child,
          ) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: FxAppTheme.getThemeFromThemeMode(),
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                key: _scaffoldKey,
                backgroundColor: themeData.backgroundColor,
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('PENDING',
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.subtitle1,
                          fontWeight: 600,
                          fontSize: 18,
                        )),
                    Flexible(
                      child: Observer(
                        builder: (_) => GridView.count(
                          padding: EdgeInsets.all(MySize.size16!),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: findAspectRatio(
                              MediaQuery.of(context).size.width),
                          mainAxisSpacing: MySize.size16!,
                          crossAxisSpacing: MySize.size16!,
                          children: List.generate(
                            store.pendingListings.length,
                            (index) {
                              return CollectionListTile(
                                  purchaseListing:
                                      store.pendingListings[index]);
                            },
                          ),
                        ),
                      ),
                    ),
                    Text('YOUR COLLECTION',
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.subtitle1,
                          fontWeight: 600,
                          fontSize: 18,
                        )),
                    Flexible(
                      child: Observer(
                        builder: (_) => ListView.separated(
                            shrinkWrap: true,
                            itemCount: store.completeListings.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1),
                            itemBuilder: (context, index) {
                              // if (index == 0 || index == store.completeListings.length) {return Container();}
                              return CollectionListTile(
                                purchaseListing: store.completeListings[index],
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Future<void> reLoad() async {
    final CollectionStore store = Provider.of<CollectionStore>(context, listen: false);
    final _oasServerApis = Provider.of<OasServerApis>(context, listen: false);
    List<PurchaseListing> allListings = await _oasServerApis.getPurchases(false);
    List<PurchaseListing> pendingListings = allListings
        .where((l) => l.status == 2 || l.status == 1 || l.status == 4)
        .cast<PurchaseListing>()
        .toList();
    List<PurchaseListing> completeListings = allListings
        .where((l) => l.status == 5)
        .cast<PurchaseListing>()
        .toList();
    store.reloadPending(pendingListings);
    store.reloadComplete(completeListings);
  }
}

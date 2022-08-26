import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oas_mobile/app/collection/collection_page.dart';
import 'package:oas_mobile/app/collection/collection_store.dart';
import 'package:oas_mobile/app/services/auth.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';
import 'package:oas_mobile/app/sign_in/logout.dart';
import 'package:oas_mobile/app/sign_in/sign_in_page_v2.dart';
import 'package:oas_mobile/flutx/themes/app_theme.dart';
import 'package:oas_mobile/flutx/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:oas_mobile/flutx/widgets/bottom_navigation_bar/bottom_navigation_bar_item.dart';
import 'package:oas_mobile/flutx/widgets/text/text.dart';
import 'package:provider/provider.dart';
import 'package:oas_mobile/flutx/utils/size_config.dart';
import 'package:oas_mobile/app/artist/my_artworks_page.dart';
import 'package:oas_mobile/app/mobx_stores/my_artworks_store.dart';
import '../market/market_page.dart';
import '../market/market_store.dart';

class LandingPageV3 extends StatefulWidget {
  @override
  _LandingPageV3State createState() => _LandingPageV3State();
}

class _LandingPageV3State extends State<LandingPageV3> {
  FxBottomNavigationBarType bottomNavigationBarType =
      FxBottomNavigationBarType.normal;
  Axis labelDirection = Axis.horizontal;
  bool showLabel = true, showActiveLabel = true;

  @override
  Widget build(BuildContext context) {
    // initialize MySize class for responsive spaces.
    MySize().init(context);

    final auth = Provider.of<Auth>(context, listen: false);
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return SignInForm.create(context);
            }

            return _bottomNavigationBar();
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _bottomNavigationBar() {
    return Scaffold(
      body: FxBottomNavigationBar(
        containerDecoration: BoxDecoration(
            color: FxAppTheme.customTheme.bgLayer2,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                  color: FxAppTheme.customTheme.shadowColor.withAlpha(100),
                  offset: Offset(8, 0),
                  blurRadius: 6)
            ]),
        activeContainerColor:
            FxAppTheme.theme.colorScheme.primary.withAlpha(30),
        fxBottomNavigationBarType: bottomNavigationBarType,
        showActiveLabel: showActiveLabel,
        showLabel: showLabel,
        activeIconSize: 28,
        iconSize: 28,
        titleSize: 14,
        titleColor: FxAppTheme.theme.colorScheme.onBackground.withAlpha(140),
        activeTitleSize: 14,
        labelDirection: labelDirection,
        activeIconColor: FxAppTheme.theme.colorScheme.onPrimary,
        iconColor: FxAppTheme.theme.colorScheme.onBackground.withAlpha(140),
        itemList: [
          FxBottomNavigationBarItem(
            page: Screen1(),
            title: "Market",
            activeIconData: Icons.house,
            iconData: Icons.house_outlined,
          ),
          FxBottomNavigationBarItem(
            page: Screen2(),
            title: "Collection",
            activeIconData: Icons.collections,
            iconData: Icons.collections_outlined,
          ),
          FxBottomNavigationBarItem(
            page: Screen3(),
            title: "Artist",
            activeIconData: Icons.brush_sharp,
            iconData: Icons.brush_outlined,
          ),
          /*
                FxBottomNavigationBarItem(
                  page: Screen4(),
                  title: "Profile",
                  activeIconData: Icons.person,
                  iconData: Icons.person_outline_rounded,
                ),*/
        ],
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final oasServerApis = Provider.of<OasServerApis>(context, listen: false);

    return Provider<MarketStore>(
      create: (_) => MarketStore(oasServerApis),
      child: MarketPage(),
    );
  }
}

class Screen2 extends StatelessWidget with Logout {
  @override
  Widget build(BuildContext context) {
    final oasServerApis = Provider.of<OasServerApis>(context, listen: false);
    final stxOasServerApis = Provider.of<STXOasServerApis>(context, listen: false);
    return Provider<CollectionStore>(
      create: (_) => CollectionStore(oasServerApis, stxOasServerApis),
      child: CollectionPage(),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final oasServerApis = Provider.of<OasServerApis>(context, listen: false);

    return Provider<MyArtworksStore>(
      create: (_) => MyArtworksStore(oasServerApis),
      child: MyArtworksPage(),
    );
  }
}

class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FxText.h6('Screen 4'),
    );
  }
}

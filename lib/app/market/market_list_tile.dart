import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oas_mobile/app/common_widgets/custom_raised_button.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/market_listing.dart';
import 'package:oas_mobile/app/transactions/place_order_page.dart';
import 'package:oas_mobile/app/services/ifps_service.dart';
import 'package:oas_mobile/flutx/utils/size_config.dart';
import 'package:oas_mobile/flutx/utils/Generator.dart';

import '../app_theme.dart';

class MarketListTile extends StatefulWidget {
  final MarketListing marketListing;

  const MarketListTile({
    Key? key,
    required this.marketListing,
  }) : super(key: key);

  @override
  _MarketListTileState createState() => _MarketListTileState();
}

class _MarketListTileState extends State<MarketListTile> with ImagesFromIfps {
  late ThemeData themeData;
  MarketListing get marketListing => widget.marketListing;
  @override
  Artwork get artwork => widget.marketListing.artwork;

  @override
  Widget build(BuildContext context) {
    String key = Generator.randomString(10);
    themeData = Theme.of(context);
    return InkWell(
      onTap: () {},
      /*
      // todo -- tap the artwork direct to detail screen
       (ShoppingProductScreen)
       () {
        Navigator.push(
            widget.rootContext,
            MaterialPageRoute(
                builder: (context) => ShoppingProductScreen(
                  heroTag: key,
                  image: widget.image,
                )));
      },
      */
      child: Container(
        decoration: BoxDecoration(
          color: themeData.cardTheme.color,
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
          boxShadow: [
            BoxShadow(
              color: themeData.cardTheme.shadowColor!.withAlpha(16),
              blurRadius: MySize.size8!,
              spreadRadius: MySize.size4!,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: EdgeInsets.all(MySize.size10!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(artwork.title,
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.subtitle1,
                        fontWeight: 600,
                        fontSize: 18,
                      )),
                  SizedBox(
                    height: 3.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          marketListing.owner.firstName +
                              " " +
                              marketListing.owner.lastName,
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                          )),
                      Text(artwork.dateCreated!.year.toString() +
                          '-' +
                          artwork.dateCreated!.month.toString(),
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: <Widget>[
                      Hero(
                        tag: key,
                        child: SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                                Radius.circular(MySize.size4!)),
                            child: primaryThumb,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Icon(
                          MdiIcons.heartOutline,
                          color:
                              themeData.colorScheme.onBackground.withAlpha(160),
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(artwork.medium, style: AppTheme.getTextStyle(
                        themeData.textTheme.subtitle2,
                      )),
                      Text(
                        artwork.length.toString() +
                            "*" +
                            artwork.width.toString() +
                            "*" +
                            artwork.height.toString() +
                            " " +
                            artwork.dimensionUnit,
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText1,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    artwork.description.toString(), style: AppTheme.getTextStyle(themeData.textTheme.bodyText2)
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  /*
                  // rating row
                  Container(
                    margin: EdgeInsets.only(top: MySize.size4!),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Generator.buildRatingStar(
                            rating: widget.star,
                            size: 16,
                            activeColor: Color(0xffffd208),
                            inactiveColor: themeData.colorScheme.onBackground),
                        Container(
                          margin: EdgeInsets.only(left: 4),
                          child: Text(widget.star.toString(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText2,
                                  fontWeight: 600)),
                        ),
                      ],
                    ),
                  ),
                  */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          marketListing.price.last.currency +
                              ": " +
                              marketListing.price.last.amount.toString(),
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.bodyText2,
                              fontWeight: 700,
                              letterSpacing: 0)),
                      CustomRaisedButton(
                        child: Text("PLACE ORDER"),
                        color: themeData.colorScheme.secondary,
                        height: 40,
                        onPressed: () => PlaceOrderPage.show(context,
                            marketListing: marketListing),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

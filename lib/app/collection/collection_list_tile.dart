import 'package:flutter/material.dart';
import 'package:oas_mobile/app/common_widgets/custom_raised_button.dart';
import 'package:oas_mobile/app/common_widgets/show_alert_dialog.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/purchaseListing.dart';
import 'package:oas_mobile/app/services/ifps_service.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';
import 'package:oas_mobile/flutx/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';

class CollectionListTile extends StatefulWidget {
  final PurchaseListing purchaseListing;

  const CollectionListTile({
    Key? key,
    required this.purchaseListing,
  }) : super(key: key);

  @override
  _CollectionListTileState createState() => _CollectionListTileState();
}

class _CollectionListTileState extends State<CollectionListTile>
    with ImagesFromIfps {
  late ThemeData themeData;
  PurchaseListing get purchaseListing => widget.purchaseListing;
  @override
  Artwork get artwork => widget.purchaseListing.artwork;

  @override
  Widget build(BuildContext context) {
    // String key = Generator.randomString(10);
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
        padding: EdgeInsets.all(MySize.size8!),
        child: Container(
          //width: MediaQuery.of(context).size.width,
          //padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(artwork.title,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTheme.getTextStyle(themeData.textTheme.bodyText1)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*
                  Text(
                      purchaseListing.owner.firstName +
                          " " +
                          purchaseListing.owner.lastName,
                      style:
                          AppTheme.getTextStyle(themeData.textTheme.bodyText2)),
                  */
                  Text(
                      artwork.dateCreated!.year.toString() +
                          '-' +
                          artwork.dateCreated!.month.toString(),
                      style:
                          AppTheme.getTextStyle(themeData.textTheme.bodyText2)),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 130,
                    minHeight: 130,
                    maxWidth: 130,
                    maxHeight: 130,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(MySize.size8!)),
                    child: primaryThumb,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(artwork.medium,
                      style:
                          AppTheme.getTextStyle(themeData.textTheme.caption)),
                  Flexible(
                    child: Text(
                        artwork.length.toString() +
                            "*" +
                            artwork.width.toString() +
                            "*" +
                            artwork.height.toString() +
                            " " +
                            artwork.dimensionUnit,
                        overflow: TextOverflow.ellipsis,
                        style:
                            AppTheme.getTextStyle(themeData.textTheme.caption)),
                  ),
                ],
              ),
              Row(children: [
                Flexible(
                  child: Text(artwork.description.toString(),
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppTheme.getTextStyle(themeData.textTheme.bodyText2)),
                ),
              ]),
              SizedBox(
                height: 3.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      purchaseListing.currency +
                          ": " +
                          purchaseListing.listingPrice.toString(),
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText2,
                          fontWeight: 600)),
                  Visibility(
                    visible: purchaseListing.status < 5,
                    child: Flexible(
                      child: CustomRaisedButton(
                        child: purchaseListing.status == 2 ? Text("CONFIRM") : Text("WAIT"),
                        color: purchaseListing.status == 2 ? themeData.colorScheme.secondary : themeData.colorScheme.onPrimary,
                        height: 25,
                        onPressed: purchaseListing.status > 1 && purchaseListing.status < 4
                            ? () => _confirmPurchaseDialog(context)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmPurchaseDialog(BuildContext context) async {
    final confirmDialog = await showAlertDialog(
      context,
      title: 'Confirm Purchase',
      content: 'STX total: ' +
          purchaseListing.listingPrice.toString() +
          " will transfer from your account to seller's account. You will receive the NFT token when transaction is done.",
      cancelActionText: 'Cancel',
      defaultActionText: 'Confirm',
    );

    if (confirmDialog!) {
      _confirmPurchase(context);
    }
  }

  Future<void> _confirmPurchase(BuildContext context) async {
    final _stxOasServerApis = Provider.of<STXOasServerApis>(context, listen: false);
    await _stxOasServerApis.confirmPurchase(artwork.artworkId!);
    _stxOasServerApis.checkConfirmPurchase(artwork.artworkId!);
  }
}

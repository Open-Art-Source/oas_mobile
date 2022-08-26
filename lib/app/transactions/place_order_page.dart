import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oas_mobile/app/common_widgets/custom_raised_button.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';
import 'package:oas_mobile/app/market/market_store.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/market_listing.dart';
import 'package:oas_mobile/app/services/ifps_service.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

class PlaceOrderPage extends StatefulWidget {
  final MarketStore marketStore;
  final MarketListing marketListing;

  const PlaceOrderPage(
      {Key? key, required this.marketListing, required this.marketStore})
      : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required MarketListing marketListing,
  }) async {
    final marketStore = Provider.of<MarketStore>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PlaceOrderPage(
          marketListing: marketListing,
          marketStore: marketStore,
        ),
      ),
    );
  }

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> with ImagesFromIfps {
  late ThemeData themeData;
  MarketListing get marketListing => widget.marketListing;
  Artwork get artwork => widget.marketListing.artwork;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: OasAppBar(title: 'Order Summary'),
      body: Container(
        color: themeData.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildForm(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomRaisedButton(
                    child: Text('Purchase'),
                    color: themeData.colorScheme.secondary,
                    height: 40,
                    onPressed: () => _placeOrder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildForm() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              Text(
                'Artwork: ' + artwork.title,
                style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                    fontWeight: 600, fontSize: 18),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                        'Artist: ' +
                            marketListing.owner.firstName +
                            " " +
                            marketListing.owner.lastName,
                        style: AppTheme.getTextStyle(themeData.textTheme.subtitle2))
                  ]),
                  Row(
                    children: [
                      Text('Medium: ' + artwork.medium,
                          style: AppTheme.getTextStyle(themeData.textTheme.subtitle2))
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          'Created by: ' +
                              artwork.dateCreated!.year.toString() +
                              '-' +
                              artwork.dateCreated!.month.toString(),
                          style: AppTheme.getTextStyle(themeData.textTheme.subtitle2))
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Dim: ' + artwork.length.toString() +
                            "*" +
                            artwork.width.toString() +
                            "*" +
                            artwork.height.toString() +
                            " " +
                            artwork.dimensionUnit,
                        style: AppTheme.getTextStyle(themeData.textTheme.subtitle2)
                      )],
                  ),
                ],
              ),
            ],
          ),
          Row(children: [
              Flexible(child: Text(
                    'Description: ' + artwork.description.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.getTextStyle(themeData.textTheme.subtitle2)
                ))]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100,
                  minHeight: 100,
                  maxWidth: 100,
                  maxHeight: 100,
                ),
                child: primaryThumb,
              ),
            ),
          ),
          Row(
            children: [
              Text('Price + Network Trans Fee: ' +
                  marketListing.price.last.amount.toString() +
                  " " + marketListing.price.last.currency,
                  style: AppTheme.getTextStyle(themeData.textTheme.subtitle2))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    final _stxOasServerApis =
        Provider.of<STXOasServerApis>(context, listen: false);
    await _stxOasServerApis.wallet();

    await _stxOasServerApis.purchase(
        artwork.artworkId!, marketListing.price.last.currency);
    _stxOasServerApis.checkPurchase(artwork.artworkId!, marketListing.price.last.currency);
    await widget.marketStore.load();
    Navigator.of(context).pop();
  }
}

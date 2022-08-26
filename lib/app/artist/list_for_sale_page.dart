import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oas_mobile/app/common_widgets/drop_down_button.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';
import 'package:oas_mobile/app/demo.dart';
import 'package:oas_mobile/app/mobx_stores/edit_artwork_store.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/listing.dart';
import 'package:oas_mobile/app/models/price.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';

class ListForSalePage extends StatefulWidget {
  final Artwork artwork;
  const ListForSalePage({Key? key, required this.artwork}) : super(key: key);

  static Future<void> show(BuildContext context, Artwork artwork) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListForSalePage(artwork: artwork),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _ListForSalePageState createState() => _ListForSalePageState();
}

class _ListForSalePageState extends State<ListForSalePage> {
  late EditArtworkStore editArtworkStore;
  late ThemeData themeData;
  static final _formKey = GlobalKey<FormState>();

  Artwork? get artwork => widget.artwork;
  List<Listing>? get listing => artwork!.listing;
  String _currency = 'STX';
  double _amount = 0.0;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    if (listing!.length != 0 ) {
      _currency = listing![0].listingPrice[0].currency;
      _amount = listing![0].listingPrice[0].amount;
      _active = listing![0].active;
    }
    editArtworkStore = EditArtworkStore(artwork);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: OasAppBar(
        title: 'Listing For Sale',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: "Save Listing",
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: Container(
        color: themeData.backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /*
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomRaisedButton(
              color: themeData.colorScheme.secondary,
              onPressed: _pickImagesFromAlbum,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    color: themeData.colorScheme.onSecondary,
                    size: 30,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  FxText.button(
                    'Upload Images',
                    color: themeData.colorScheme.onSecondary,
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) => PhotosActionGridViewWidget(
                images: editArtworkStore.artworkImages.value ?? []),
          ),
          */
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyDropdownButton(
                  dropdownItems: MyApp.blockChain == "Stacks" ? ['STX'] : ['ETH', 'STX'],
                  // ['ETH', 'STX'],
                  initialSelectedItem: _currency,
                  onSaved: (value) => _currency = value,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: '0.0',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    initialValue: '$_amount',
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    onSaved: (value) =>
                        _amount = double.tryParse(value!) ?? 0.0,
                  ),
                ),
              ],
            ),
          ),
          // _blockChainButtons(),
          // active toggle
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Do you wish to active your artwork?',
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle1,
                          )),
                      Text(
                          'Activating means it will be added to the marketplace and the image and information will no longer be able to changed.',
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle2,
                          )),
                    ],
                  ),
                ),
                Switch(
                  value: _active,
                  onChanged: (bool newValue){
                    setState(() {
                      _active = newValue;
                      print('isActive status: $_active');
                    });
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    final stxOasServerApis = Provider.of<STXOasServerApis>(context, listen: false);
    if (_validateAndSaveForm()) {
      List<Listing>? listing = widget.artwork.listing;
      if (listing!.length != 0) {
        listing[0].active = _active;
        listing[0].listingPrice[0].currency = _currency;
        listing[0].listingPrice[0].amount = _amount;
      } else {
        listing = [ new Listing(
            active: _active,
            listingPrice: [
              new Price(amount: _amount, currency: _currency)
            ],
          ) ];
      }
      await stxOasServerApis.listForSale(
        artwork!.artworkId!,
        listing[0].listingPrice[0].currency,
        amount: listing[0].listingPrice[0].amount,
        active: listing[0].active,
      );
      //await widget.myArtworksStore.load();
      Navigator.of(context).pop();
    }
  }

}

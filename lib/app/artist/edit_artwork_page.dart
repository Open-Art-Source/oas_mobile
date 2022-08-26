import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oas_mobile/app/artist/list_for_sale_page.dart';
import 'package:oas_mobile/app/common_widgets/custom_raised_button.dart';
import 'package:oas_mobile/app/common_widgets/drop_down_button.dart';
import 'package:oas_mobile/app/common_widgets/oas_app_bar.dart';
import 'package:oas_mobile/app/common_widgets/photo_action_grid_view.dart';
import 'package:oas_mobile/app/common_widgets/show_alert_dialog.dart';
import 'package:oas_mobile/app/common_widgets/show_exception_alert_dialog.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/mobx_stores/edit_artwork_store.dart';
import 'package:oas_mobile/app/mobx_stores/my_artworks_store.dart';
import 'package:oas_mobile/app/services/ifps_service.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';
import 'package:oas_mobile/flutx/widgets/text/text.dart';
import 'package:oas_mobile/wallet_connect/walletconnect.dart';
import 'package:oas_mobile/wallet_connect/web3.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../demo.dart';

class EditArtworkPage extends StatefulWidget {
  final MyArtworksStore myArtworksStore;
  final Artwork? artwork;

  const EditArtworkPage({Key? key, required this.myArtworksStore, this.artwork})
      : super(key: key);

  static Future<void> show(BuildContext context, {Artwork? artwork}) async {
    final myArtworksStore =
        Provider.of<MyArtworksStore>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EditArtworkPage(myArtworksStore: myArtworksStore, artwork: artwork),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditArtworkPageState createState() => _EditArtworkPageState();
}

class _EditArtworkPageState extends State<EditArtworkPage> with ImagesFromIfps {
  late EditArtworkStore editArtworkStore;

  static final _formKey = GlobalKey<FormState>();
  final String walletAppLink = 'https://metamask.app.link/';
  String? _artworkId;
  String? _artistId;
  String? _title;
  String? _medium;
  double? _height;
  double? _width;
  double? _length;
  String? _desc;
  String _dimUnit = 'Inch';
  DateTime? _dateCreated;
  /*
  String? _imageFilesHash;
  String? _primaryImageFileName;
  String? _shortDescription;
  */
  String? _tokenId;
  String? _contractAddress;

  Artwork? get artwork => widget.artwork; // used in mixin ImagesFromIfps

  late ThemeData _themeData;

  @override
  void initState() {
    super.initState();
    if (artwork != null) {
      _artistId = artwork!.artistId;
      _artworkId = artwork!.artworkId;
      _title = artwork!.title;
      _medium = artwork!.medium;
      _height = artwork!.height;
      _width = artwork!.width;
      _length = artwork!.length;
      _desc = artwork!.description;
      _dimUnit = artwork!.dimensionUnit;
      _dateCreated = artwork!.dateCreated;
      /*
      _imageFilesHash = widget.artwork!.imageFilesHash;
      _primaryImageFileName = widget.artwork!.primaryImageFileName;
      _shortDescription = widget.artwork!.shortDescription;
      */
      _tokenId = MyApp.blockChain == "Stacks"
          ? artwork!.stxTokenId
          : artwork!.nftTokenId;
      _contractAddress = MyApp.blockChain == "Stacks"
          ? artwork!.stxContractAddress
          : artwork!.nftContractAddress;
    }

    editArtworkStore = EditArtworkStore(artwork);
  }

  Future<void> _pickImagesFromAlbum() async {
    List<Asset>? _resultList;

    try {
      _resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: editArtworkStore.imagesFromPicker ?? [],
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      //todo exception handling
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // todo check??
    editArtworkStore.setImagesFromPicker(_resultList!);
  }

  bool _validateAndSaveForm() {
    final _form = _formKey.currentState;

    if (_form!.validate()) {
      _form.save();
      return true;
    }

    return false;
  }

  Future<void> _submit(BuildContext context) async {
    final _oasServerApis = Provider.of<OasServerApis>(context, listen: false);
    if (_validateAndSaveForm()) {
      Artwork? artwork = this.widget.artwork;
      if (artwork != null) {
        artwork.title = _title!;
        artwork.medium = _medium!;
        artwork.height = _height;
        artwork.width = _width;
        artwork.length = _length;
        artwork.description = _desc;
        artwork.dimensionUnit = _dimUnit;
        artwork.dateCreated = _dateCreated ?? DateTime.now();
        /*
        artwork.listing!.active = _active;
        artwork.listing!.listingPrice[0].currency = _currency;
        artwork.listing!.listingPrice[0].amount = _amount ?? 0.0;
        */
      } else {
        artwork = Artwork(
          title: _title!,
          medium: _medium!,
          height: _height,
          width: _width,
          length: _length,
          description: _desc,
          dimensionUnit: _dimUnit,
          dateCreated: _dateCreated ?? DateTime.now(),
          /*
          listing: Listing(
            active: _active,
            listingPrice: [
              new Price(amount: _amount ?? 0.0, currency: _currency)
            ],
          ),
          */
        );
      }
      await _oasServerApis.registerArtwork(
          artwork, editArtworkStore.imagesFromPicker);
      await widget.myArtworksStore.load();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return Scaffold(
      appBar: OasAppBar(
        title: widget.artwork == null ? 'New Work' : 'Edit Work',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            tooltip: "Save artwork",
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: Container(
        color: _themeData.backgroundColor,
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue: _title,
              validator: (value) => value!.isNotEmpty ? null : 'Required',
              onSaved: (value) => _title = value,
              maxLength: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Medium'),
              initialValue: _medium,
              validator: (value) => value!.isNotEmpty ? null : 'Required',
              onSaved: (value) => _medium = value,
              maxLength: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'H',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    initialValue: _height != null ? '$_height' : null,
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    onSaved: (value) => _height = double.tryParse(value!) ?? 0,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'W',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    initialValue: _width != null ? '$_width' : null,
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    onSaved: (value) => _width = double.tryParse(value!) ?? 0,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'L',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    initialValue: _length != null ? '$_length' : null,
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    onSaved: (value) => _length = double.tryParse(value!) ?? 0,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                MyDropdownButton(
                  dropdownItems: ['Inch', 'Feet', 'CM', 'Meter'],
                  initialSelectedItem: _dimUnit,
                  onSaved: (value) => _dimUnit = value,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderSide: BorderSide()),
                semanticCounterText: 'text',
              ),
              initialValue: _desc,
              keyboardType: TextInputType.text,
              maxLines: 5,
              maxLength: 3500,
              onSaved: (value) => _desc = value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomRaisedButton(
              color: _themeData.colorScheme.secondary,
              onPressed: _pickImagesFromAlbum,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    color: _themeData.colorScheme.onSecondary,
                    size: 30,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Upload Images'),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) => PhotosActionGridViewWidget(
                images: editArtworkStore.artworkImages.value ?? []),
          ),
          _blockChainButtons(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Observer(
              builder: (_) => CustomRaisedButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_business,
                      color: _themeData.colorScheme.onSecondary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('List For Sale'),
                  ],
                ),
                color: _themeData.colorScheme.secondary,
                onPressed: editArtworkStore.mintOnce || editArtworkStore.minted
                    ? () => _stxListForSale()
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blockChainButtons() {
    if (MyApp.blockChain == "Stacks")
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Observer(
          builder: (_) => CustomRaisedButton(
            color: _themeData.colorScheme.secondary,
            child: Text('Mint NFT'),
            onPressed: editArtworkStore.mintOnce || editArtworkStore.minted
                ? null
                : () => _stxMintNFT(editArtworkStore.minted) ,
          ),
        ),
      );
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomRaisedButton(
              color: _themeData.colorScheme.secondary,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.merge_type_rounded,
                    color: _themeData.colorScheme.onSecondary,
                    size: 30,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  FxText.button(
                    'Connect To Wallet',
                    color: _themeData.colorScheme.onSecondary,
                  ),
                ],
              ),
              onPressed: () => _createWCSession(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.sh1(
                  'Why must I connect my MetaMask wallet?',
                  color: Colors.black,
                ),
                FxText.b2(
                  'Need to explain what the user can expect by engaging connect wallet.',
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Observer(
              builder: (_) => CustomRaisedButton(
                color: _themeData.colorScheme.primary,
                child: Text('Mint NFT'),
                onPressed:
                    editArtworkStore.walletConnection ? () => _mintNFT() : null,
              ),
            ),
          ),
        ],
      );
  }

  void _stxMintNFT(bool? reSubmit) async {
    final _stxOasServerApis =
        Provider.of<STXOasServerApis>(context, listen: false);
    await _stxOasServerApis.wallet();
    // todo add submit to make sure artwork ID exist
    // _submit(context);
    String? _contractAddr = await _stxOasServerApis.makeNFT(artwork!.artworkId!,
        token: 'STX', reSubmit: reSubmit);
    editArtworkStore.setMintOnce(_contractAddr != null);
    await Future.delayed(Duration(milliseconds: 500));
    _stxOasServerApis.collectNFT(artwork!.artworkId!).then((value) => editArtworkStore.setMinted(value ==3));
  }

  void _stxListForSale() async {
    final _stxOasServerApis =
        Provider.of<STXOasServerApis>(context, listen: false);
    if (!editArtworkStore.minted) {
      try {
        int _mintResult = await _stxOasServerApis.collectNFT(artwork!.artworkId!);
        if (_mintResult == 1) {
          editArtworkStore.setMintOnce(false);
          editArtworkStore.setMinted(false);
          await showAlertDialog(context,
              title: 'Alert',
              content: 'NFT mint failed. Try mint again then List for Sale.',
              defaultActionText: 'OK');
        } else if (_mintResult == 2) {
          editArtworkStore.setMintOnce(true);
          editArtworkStore.setMinted(false);
          await showAlertDialog(context,
              title: 'Alert',
              content: 'NFT is minting. Please wait until minting is done.',
              defaultActionText: 'OK');
        } else if (_mintResult == 3) {
          editArtworkStore.setMintOnce(true);
          editArtworkStore.setMinted(true);
          ListForSalePage.show(context, artwork!);
        }
      } catch (error) {
        print('makeNFT failed $error');
      }
    } else {
      ListForSalePage.show(context, artwork!);
    }

  }

  Future<WCSession> _createWCSession() async {
    const bridgeUrl = 'https://wcbridge.garyng.com';
    const myMeta = {
      'description': 'Open Art Source',
      'name': 'Open Art Source',
      'url': 'https://www.openartsource.io/',
      'icons': [
        'https://openartsource.io/wp-content/uploads/2019/05/OAS_LOGO-long.png'
      ]
    };
    late WCSession wcSession;
    try {
      WCConnectionRequest sessionRequest =
          await WCSession.createSession(bridgeUrl, myMeta,
              jsonRpcHandler: {
                '_': [echo_handler]
              },
              chainId: 1);
      print(sessionRequest.wcUri);

      final String uLink = sessionRequest.wcUri.universalLink(walletAppLink);
      //String wcUrl = sessionRequest.wcUri.toString();
      await canLaunch(uLink)
          ? await launch(uLink, forceSafariVC: false)
          : throw 'Could not launch $uLink';

      wcSession = await sessionRequest.wcSessionRequest;
      await wcSession.connect();
      //print('Connected');
      //check wsSession status, if successful, call mobx action to set connected to true
      if (wcSession.isConnected) {
        editArtworkStore.wcSession = wcSession;
        editArtworkStore.setConnection(true);
        print('connection status: ${editArtworkStore.walletConnection}');
      }
    } on WCCustomException catch (error) {
      //print('session request error ${error.error}');
      showExceptionAlertDialog(
        context,
        title: 'Wallet Connection Error',
        exception: error,
      );
    } catch (error) {
      print('session request error $error');
    }
    return wcSession;
  }

  void _mintNFT() async {
    final wcSession = editArtworkStore.wcSession;
    var mintTx = mintTokenTx(wcSession!.theirAccounts![0],
        editArtworkStore.artwork!.imageFilesHash!);
    var params = [
      {
        'from': wcSession.theirAccounts![0],
        'to': mintTx.item1,
        'data': mintTx.item2,
      }
    ];
    try {
      var x = await wcSession.sendRequest('eth_sendTransaction', params);
      print('eth_sendTransaction sent $x');

      // switch over to wallet app
      await canLaunch(walletAppLink)
          ? launch(walletAppLink, forceSafariVC: false)
          : throw 'Could not launch $walletAppLink';

      var y = await x.item2;
      print('eth_sendTransaction result $y');
      editArtworkStore.setMintOnce(true);
    } catch (error) {
      editArtworkStore.setMintOnce(false);
      print('eth_sendTransaction failed $error');
    }

    print('mint NFT status: ${editArtworkStore.mintOnce}');

    params = [
      {
        'approved': false,
      }
    ];

    var x = await wcSession.sendRequest('wc_sessionUpdate', params);
    print('wc_sessionUpdate sent $x');
  }
}

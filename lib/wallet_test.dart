import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oas_mobile/wallet_connect//walletconnect.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Walletconnect Test"),
        ),
        body: Container(
            alignment: Alignment.center,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WalletConnectWidget();
                    }));
                  },
                  child: Text("Connect to Wallet"),
                ))
              ],
            )));
  }
}

class WalletConnectWidget extends StatelessWidget {
  final String walletAppLink = 'https://metamask.app.link/';
  const WalletConnectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Connect to Wallet"),
            //backgroundColor: Colors.redAccent,
          ),
          body: _renderBody(snapshot),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: _createWCSession(),
    );
  }

  Widget _renderBody(AsyncSnapshot snapshot) {
    // Checking if future is resolved or not
    if (snapshot.connectionState == ConnectionState.done) {
      // If we got an error
      if (snapshot.hasError) {
        return Center(
          child: Text(
            '${snapshot.error} occured',
            style: TextStyle(fontSize: 18),
          ),
        );

        // if we got our data
      } else if (snapshot.hasData) {
        // Extracting data from snapshot object
        final wcSession = snapshot.data as WCSession;
        return Center(
          child: ElevatedButton(
            onPressed: () => _sendTx(wcSession),
            child: Text('Send a Tx'),
          ),
        );
      }
    }

    // Displaying LoadingSpinner to indicate waiting state
    return Center(
      child: CircularProgressIndicator(),
    );
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

      print('Connected');
    } on WCCustomException catch (error) {
      print('session request error ${error.error}');
    } catch (error) {
      print('session request error $error');
    }
    return wcSession;
  }

  void _sendTx(WCSession wcSession) async {
    // send some eth
    BigInt gWei = BigInt.from(1000000000);
    var params = [
      {
        'from': wcSession.theirAccounts![0],
        'to': wcSession.theirAccounts![0],
        'data': '0x',
        'gas': '0x' + 21000.toRadixString(16),
        'gasPrice': '0x' + (gWei * BigInt.from(2)).toRadixString(16),
//          'value': '0x0',
        'value': '0x' + (gWei * gWei ~/ BigInt.from(1000)).toRadixString(16),
//          'nonce': '0x4',
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
    } catch (error) {
      print('eth_sendTransaction failed ${error.toString()}');
    }
    params = [
      {
        'approved': false,
      }
    ];

    var x = await wcSession.sendRequest('wc_sessionUpdate', params);
    print('wc_sessionUpdate sent $x');
  }
}

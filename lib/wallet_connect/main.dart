import 'dart:html';
import 'walletconnect.dart';
import 'web3.dart';

void main() {
  querySelector('#output')!.text = 'Your Dart app is running.';
  querySelector('#connectDApp')!.onClick.listen((event) async {
    print('wallet connect invoked');
    var wcUri = (querySelector('#wcUri') as InputElement).value;
    var sessionRequest =
    await WCSession.connectSession(wcUri!, jsonRpcHandler: {
      '_': [echo_handler]
    });
    var wcSession = sessionRequest.item1;
    var request = sessionRequest.item2;
    // ignore: omit_local_variable_types
    List<String> accounts = ['0x1234567890123456789012345678901234567890'];
    var myMeta = {
      'description': 'Testing DART Wallet',
      'name': 'test dart',
      'url': 'https://www.google.com',
      'icons': [
        'https://raw.githubusercontent.com/MetaMask/brand-resources/master/SVG/metamask-fox.svg'
      ]
    };
    print('session request from $request');
    var result = await wcSession.sendSessionRequestResponse(
        request, 'my test wallet', myMeta, accounts, true,
        chainId: 1, ssl: true, rpcUrl: 'https://infura.io');
    print('session request ${result.item1} approved $wcSession');
    await Future.delayed(Duration(seconds: 10), () {});
    var pong = await wcSession.sendRequest('wc_pong', []);
    var id = pong.item1;
    print('wc_pong $id request');
    var requestResult = await pong.item2;
    print('wc_pong $id result $requestResult');
  });
  querySelector('#connectWallet')!.onClick.listen((event) async {
    var symbol = await getSymbol('http://localhost:8545');
    print(symbol[0]);
    var txData = mintTokenTx(
        '0x3274e7409A257a8865f23Ade77A1827e69d923a1', 'https://www.google.com');
    print('${txData.item1}, ${txData.item2}');
    var event = await getTokenId(
        'http://localhost:8545', null, 'https://www.google.com');
    print('$event');
    var iosWalletRegistry = await getWCWalletRegistry();
    //var androidWalletRegistry = await getWCWalletRegistry(ios: false);
    iosWalletRegistry.forEach((w) {
      print('${w?.name} - ${w?.iosDeepLink}');
    });
    var bridgeUrl = (querySelector('#bridgeUrl') as InputElement).value;
    var myMeta = {
      'description': 'Testing DART DApp',
      'name': 'test dart',
      'url': 'https://www.blabla.com/',
      'icons': ['https://blabla.com/favicon.png']
    };
    try {
      var sessionRequest = await WCSession.createSession(bridgeUrl!, myMeta,
          jsonRpcHandler: {
            '_': [echo_handler]
          },
          chainId: 1);
      print(sessionRequest.wcUri);
      (querySelector('#wcUri') as InputElement).value =
          sessionRequest.wcUri.toString();
      (querySelector('#deepLink') as InputElement).value =
//          sessionRequest.wcUri.universalLink('https://rnbwapp.com/');

      sessionRequest.wcUri.universalLink('https://metamask.app.link/');
      sessionRequest.wcUri.toString();
      var wcSession = await sessionRequest.wcSessionRequest;
      print('session request replied $wcSession');
      // await wcSession.close();
      // await Future.delayed(Duration(seconds: 300), () {});
      // await wcSession.connect();
      // print('reconnect');
      var GWei = BigInt.from(1000000000);
      var mintTx =
      mintTokenTx(wcSession.theirAccounts![0], 'https://www.google.com');
      var params = [
        {
          'from': wcSession.theirAccounts![0],
//          'to': wcSession.theirAccounts![0],
//          'data': '0x',
//          'gas': '0x' + 21000.toRadixString(16),
          'to': mintTx.item1,
          'data': mintTx.item2,
//          'gas': '0x' + 200000.toRadixString(16),
//          'gasPrice': '0x' + (GWei * BigInt.from(2)).toRadixString(16),
//          'value': '0x0',
//          'value': '0x' + (GWei * GWei ~/ BigInt.from(1000)).toRadixString(16),
//          'nonce': '0x4',
        }
      ];
      try {
        var x = await wcSession.sendRequest('eth_sendTransaction', params);
        print('eth_sendTransaction sent $x');
        var y = await x.item2;
        print('eth_sendTransaction result $y');
      } catch (error) {
        print('eth_sendTransaction failed $error');
      }
      params = [
        {
          'approved': false,
        }
      ];
      var x = await wcSession.sendRequest('wc_sessionUpdate', params);
      print('wc_sessionUpdate sent $x');

      // if (wcSession.isActive) {
      //   var ping = await wcSession.sendRequest('wc_ping', []);
      //   var id = ping.item1;
      //   print('wc_ping $id request');
      //   var requestResult = await ping.item2;
      //   print('wc_ping idresultrequestResult');
      // }
    } on WCCustomException catch (error) {
      print('session request error ${error.error}');
    } catch (error) {
      print('session request error $error');
    }
  });
}
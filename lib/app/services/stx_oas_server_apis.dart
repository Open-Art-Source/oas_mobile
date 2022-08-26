import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oas_mobile/app/services/auth.dart';

class STXOasServerApis {
  final apiServerUrl = 'https://oasbeta.us-east-2.elasticbeanstalk.com/';
  String idFromCurrentDateTime() => DateTime.now().toIso8601String();
  final Auth auth;

  STXOasServerApis({required this.auth});

  Future<String> get firebaseIdToken async => await auth.currentUser!.getIdToken();

  Future<String> wallet() async {
    final uri = Uri.parse('$apiServerUrl/api/person');
    final response = await _jsonRpc(uri: uri, method: 'wallet');
    print('wallet status: ${response.statusCode}');
    print('wallet body: ${response.body}');
    return jsonDecode(response.body)['result']['stx_address'];
  }

  Future<String?> makeNFT(String artworkId, {String? token, bool? reSubmit}) async {
    final uri = Uri.parse('$apiServerUrl/api/artist');
    final response = await _jsonRpc(uri: uri, method: 'make_nft', params: [artworkId, {'token': token, 're_submit' : reSubmit}]);
    print('makeNFT status: ${response.statusCode}');
    print('makeNFT body: ${response.body}');
    return jsonDecode(response.body)['result']['contract_address'];
  }
  Future<int> collectNFT(String artworkId) async {
    final uri = Uri.parse('$apiServerUrl/api/artist');
    final response = await _jsonRpc(uri: uri, method: 'collect_nft', params: [artworkId]);
    print('collectNFT status: ${response.statusCode}');
    print('collectNFT body: ${response.body}');

    String? contractAddress = jsonDecode(response.body)['result']['contract_address'];
    String? tokenID = jsonDecode(response.body)['result']['token_id'];
    var earlier = DateTime.now().subtract(const Duration(minutes: 30));
    bool expire = earlier.isAfter(HttpDate.parse(jsonDecode(response.body)['result']['datetime_created']));

    if (contractAddress == null) {print('collectNFT result: never minted'); return 0;}            // never mint
    else if (tokenID == null && expire) {print('collectNFT result: failed');return 1;}     // fail
    else if (tokenID == null) {print('collectNFT result: minting');return 2;}               // minting
    else {print('collectNFT result: success');return 3;}                                    // success
  }

  Future<void> listForSale(String artworkID, String currency, {double? amount, bool? active, bool? reSubmit}) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final params = [artworkID, currency, {'amount' : amount, 'active' : active, 're_submit' : reSubmit}];
    final response = await _jsonRpc(uri: uri, method: 'list_for_sale', params: params);
    print('listForSale status: ${response.statusCode}');
    print('listForSale body: ${response.body}');
  }
  Future<void> checkListing(String artworkID, String currency) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final params = [artworkID, currency];
    final response = await _jsonRpc(uri: uri, method: 'check_listing', params: params);
    print('checkListing status: ${response.statusCode}');
    print('checkListing body: ${response.body}');
  }

  Future<void> purchase(String artworkID, String currency, {bool? reSubmit}) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final response = await _jsonRpc(uri: uri, method: 'purchase', params: [artworkID,currency, {'re_submit' : reSubmit}]);
    print('purchase status: ${response.statusCode}');
    print('purchase body: ${response.body}');
  }
  Future<void> checkPurchase(String artworkID, String currency) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final response = await _jsonRpc(uri: uri, method: 'check_purchase', params: [artworkID,currency]);
    print('checkPurchase status: ${response.statusCode}');
    print('checkPurchase body: ${response.body}');
  }

  Future<void> confirmPurchase(String artworkID, {bool? reSubmit}) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final response = await _jsonRpc(uri: uri, method: 'confirm_purchase', params: [artworkID, {'re_submit' : reSubmit}]);
    print('confirmPurchase status: ${response.statusCode}');
    print('confirmPurchase body: ${response.body}');
  }
  Future<void> checkConfirmPurchase(String artworkID) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final response = await _jsonRpc(uri: uri, method: 'check_confirm_purchase', params: [artworkID]);
    print('checkConfirmPurchase status: ${response.statusCode}');
    print('checkConfirmPurchase body: ${response.body}');
  }

  Future<http.Response> _jsonRpc({required Uri uri, required String method, dynamic params}) async {

    final body = jsonEncode({
      'jsonrpc': '2.0',
      'method': method,
      'id': idFromCurrentDateTime(),
      'params': params ?? [],
    });

    final response = await http.post(
      uri,
      body: body,
      headers: {
        'Authorization': 'Bearer ${await firebaseIdToken}',
        'Content-Type': 'application/json'
      },
    );

    return response;
  }

}

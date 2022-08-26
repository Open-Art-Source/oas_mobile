import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/market_listing.dart';
import 'package:oas_mobile/app/models/purchaseListing.dart';
import 'package:oas_mobile/app/services/auth.dart';

class OasServerApis {
  // todo: put this in some config file
  final apiServerUrl = 'https://oasbeta.us-east-2.elasticbeanstalk.com/';
  String idFromCurrentDateTime() => DateTime.now().toIso8601String();
  final Auth auth;

  OasServerApis({required this.auth});

  Future<String> get firebaseIdToken async =>
      await auth.currentUser!.getIdToken();

  Future<void> registerNewUser() async {
    final uri = Uri.parse('$apiServerUrl/api/auth');
    final response = await _jsonRpc(uri: uri, method: 'register');

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<String?> registerArtwork(Artwork artwork, List<Asset>? images) async {
    final url = Uri.parse('$apiServerUrl/upload_file');
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer ${await firebaseIdToken}';
    request.fields['artwork'] = jsonEncode(artwork);

    // add images to http request
    if (images != null && images.isNotEmpty) {
      List<ByteData> imagesByteData =
      await Future.wait(images.map((image) => image.getByteData()));

      List<ByteData> thumbsByteData = await Future.wait(
          images.map((image) => image.getThumbByteData(300, 300)));

      for (int i = 0; i < imagesByteData.length; i++) {
        List<int> image = imagesByteData[i]
            .buffer
            .asUint8List(
            imagesByteData[i].offsetInBytes, imagesByteData[i].lengthInBytes)
            .cast<int>();

        request.files.add(http.MultipartFile.fromBytes('image-$i', image,
            filename: images[i].name));
      }

      for (int i = 0; i < thumbsByteData.length; i++) {
        List<int> image = thumbsByteData[i]
            .buffer
            .asUint8List(
            thumbsByteData[i].offsetInBytes, thumbsByteData[i].lengthInBytes)
            .cast<int>();

        request.files.add(http.MultipartFile.fromBytes('thumb-$i', image,
            filename: 'thumb_${images[i].name}'));
      }
    }

    var res = await request.send();
    print('registerArtwork status: ${res.statusCode}');
    print('Response reason phrase: ${res.reasonPhrase}');
    final resBody = await res.stream.bytesToString();
    print('registerArtwork body: $resBody');
    return res.reasonPhrase;
  }

  Future<List<Artwork>> getMyArtworks() async {
    final uri = Uri.parse('$apiServerUrl/api/artist');
    final response = await _jsonRpc(uri: uri, method: 'get_artwork');

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    List<Artwork> artworks = (jsonDecode(response.body)['result'] as List)
        .map((i) => Artwork.fromMap(i))
        .toList();

    return artworks;
  }

  Future<List<MarketListing>> getListings() async {
    final uri = Uri.parse('$apiServerUrl/api/person');
    final response = await _jsonRpc(uri: uri, method: 'get_listing');

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    List<MarketListing> listings = (jsonDecode(response.body)['result'] as List)
        .map((i) => MarketListing.fromJson(i))
        .toList();

    return listings;
  }

  Future<List<PurchaseListing>> getPurchases(bool asSeller) async {
    final uri = Uri.parse('$apiServerUrl/api/artwork');
    final response = await _jsonRpc(uri: uri, method: 'get_purchases', params: [{"as_seller": asSeller}]);

    print('getPurchases status: ${response.statusCode}');
    print('getPurchases body: ${response.body}');

    List<PurchaseListing> listings = (jsonDecode(response.body)['result'] as List)
        .map((i) => PurchaseListing.fromJson(i))
        .toList();
    return listings;
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

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/ipfs_metadata.dart';

mixin ImagesFromIfps {
  // todo: need a more robust way to access ipfs files
  final String _ipfsGatewayUri = 'ipfs.io';
  Artwork? get artwork;

  Widget get primaryThumb => getImage('thumb_${artwork?.primaryImageFileName}');

  Future<List<Widget>> get allThumbs async {
    // metadata.json
    final response = await _get('ipfs/${artwork?.imageFilesHash}/metadata.json');
    final metadata = IpfsMetadata.fromJson(jsonDecode(response.body));
    final List<String> thumbFileNames = metadata.images
        .where((filename) => filename.startsWith('thumb_'))
        .toList();

    final thumbs = thumbFileNames.map((filename) => getImage(filename)).toList();
    return thumbs;
  }

  Widget getImage(String imageName) => CachedNetworkImage(
    imageUrl:
    'https://$_ipfsGatewayUri/ipfs/${artwork!.imageFilesHash}/$imageName',
    fit: BoxFit.fill,
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );

  Future<http.Response> _get(String unencodedPath) async {
    final response = await http.get(Uri.https(_ipfsGatewayUri, unencodedPath));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to get $_ipfsGatewayUri/$unencodedPath');
    }
  }
}

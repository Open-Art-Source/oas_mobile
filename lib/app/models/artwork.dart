import 'dart:io';
import 'listing.dart';

class Artwork {
  final String? artworkId;
  String? artistId;
  String title;
  String medium;
  double? length;
  double? width;
  double? height;
  String? description;
  String? shortDescription;
  DateTime? dateCreated;
  String? nftTokenId;
  String? nftContractAddress;
  String? imageFilesHash;
  String? primaryImageFileName;
  String dimensionUnit;
  String? stxTokenId;
  String? stxContractAddress;
  List<Listing>? listing;

  Artwork({
    this.artworkId,
    required this.title,
    required this.medium,
    required this.dimensionUnit,
    this.height,
    this.width,
    this.length,
    this.description,
    this.shortDescription,
    this.dateCreated,
    this.imageFilesHash,
    this.primaryImageFileName,
    this.listing,
  });

  Artwork.allAttributes(
      {this.artistId,
        this.artworkId,
        this.dateCreated,
        this.description,
        required this.dimensionUnit,
        this.height,
        this.imageFilesHash,
        this.length,
        this.listing,
        required this.medium,
        this.nftContractAddress,
        this.nftTokenId,
        this.primaryImageFileName,
        this.shortDescription,
        required this.title,
        this.width,
        this.stxTokenId,
        this.stxContractAddress,
      });

  factory Artwork.fromMap(Map<String, dynamic> json) {
    return Artwork.allAttributes(
      artistId: json['artist_id'],
      artworkId: json['artwork_id'],
      dateCreated: json['date_created'] != null ? HttpDate.parse(json['date_created']) : HttpDate.parse(DateTime.now().toUtc().toIso8601String()),
      description: json['description'],
      dimensionUnit: json['dimension_unit'],
      height: json['height'],
      imageFilesHash: json['image_files_hash'],
      length: json['length'],
      listing: json['listing'] != null ? json['listing'].map((v) => new Listing.fromJson(v)).toList().cast<Listing>() : [],
      //json['listing'][0] != null ? Listing.fromJson(json['listing'][0]) : null,
      medium: json['medium'],
      nftContractAddress: json['nft_contract_address'],
      nftTokenId: json['nft_token_id'],
      primaryImageFileName: json['primary_image_file_name'],
      shortDescription: json['short_description'],
      stxContractAddress: json['stx_contract_address'],
      stxTokenId: json['stx_token_id'],
      title: json['title'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artist_id': this.artistId,
      'artwork_id': this.artworkId,
      'date_created': this.dateCreated != null ? HttpDate.format(this.dateCreated!) : HttpDate.format(DateTime.now().toUtc()),
      'description': this.description,
      'dimension_unit': this.dimensionUnit,
      'height': this.height,
      'image_files_hash': this.imageFilesHash,
      'length': this.length,
      // 'listing': this.listing != null ? this.listing!.map((v) => v.toJson()).toList() : [],
      'medium': this.medium,
      'nft_contract_address': this.nftContractAddress,
      'nft_token_id': this.nftTokenId,
      'primary_image_file_name': this.primaryImageFileName,
      'short_description': this.shortDescription,
      'stx_contract_address': this.stxContractAddress,
      'stx_token_id': this.stxTokenId,
      'title': this.title,
      'width': this.width,
    };
  }



}

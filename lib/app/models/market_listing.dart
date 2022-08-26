import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/models/price.dart';

class MarketListing {
  bool active;
  Artwork artwork;
  String artworkId;
  String listingId;
  Owner owner;
  int ownershipId;
  String personId;
  List<Price> price;
  int status;

  MarketListing({required this.active,
    required this.artwork,
    required this.artworkId,
    required this.listingId,
    required this.owner,
    required this.ownershipId,
    required this.personId,
    required this.price,
    required this.status,
  });

  factory MarketListing.fromJson(Map<String, dynamic> json) {

    return MarketListing(
        active: json['active'] == 1,
        artwork: new Artwork.fromMap(json['artwork']),
        artworkId: json['artwork_id'],
        listingId: json['listing_id'],
        owner: new Owner.fromJson(json['owner']),
        ownershipId: json['ownership_id'],
        personId: json['person_id'],
        price: json['price'].map((v) => new Price.fromJson(v)).toList().cast<Price>(),
        status: json['status'],
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active ? 1 : 0;
    data['artwork'] = this.artwork.toJson();
    data['artwork_id'] = this.artworkId;
    data['listing_id'] = this.listingId;
    data['owner'] = this.owner.toJson();
    data['ownership_id'] = this.ownershipId;
    data['person_id'] = this.personId;
    data['price'] = this.price.map((v) => v.toJson()).toList();
    data['status'] = this.status;
    return data;
  }
}


class Owner {
  late String custodianWalletAddress;
  late String dateTimeJoined;
  late String firstName;
  late String lastName;
  late String personId;

  Owner({required this.custodianWalletAddress,
    required this.dateTimeJoined,
    required this.firstName,
    required this.lastName,
    required this.personId});

  Owner.fromJson(Map<String, dynamic> json) {
    custodianWalletAddress = json['custodian_wallet_address'];
    dateTimeJoined = json['date_time_joined'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    personId = json['person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custodian_wallet_address'] = this.custodianWalletAddress;
    data['date_time_joined'] = this.dateTimeJoined;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['person_id'] = this.personId;
    return data;
  }
}

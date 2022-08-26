
import 'package:oas_mobile/app/models/price.dart';

class Listing {
  bool active;
  String? artworkId;
  String? listingId;
  List<Price> listingPrice;
  //double amount;
  //String currency;

  Listing({
    required this.active,
    this.artworkId,
    this.listingId,
    required this.listingPrice,
    //required this.amount,
    //required this.currency,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      active: json['active'] == 1,
      artworkId: json['artwork_id'],
      listingId: json['listing_id'],
      listingPrice: json['listing_price'].map((v) => new Price.fromJson(v)).toList().cast<Price>(),
      //amount: json['listing_price'].last['amount'],
      //currency: json['listing_price'].last['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active ? 1 : 0;
    data['artwork_id'] = this.artworkId;
    data['listing_id'] = this.listingId;
    data['listing_price'] = this.listingPrice.map((v) => v.toJson()).toList();
    //data['amount'] = this.amount;
    //data['currency'] = this.currency;
    return data;
  }
}

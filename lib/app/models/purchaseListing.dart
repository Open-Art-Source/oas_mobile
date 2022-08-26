import 'package:oas_mobile/app/models/artwork.dart';

class PurchaseListing {
  // todo - api result need to include artist, and owner
  Artwork artwork;
  String buyerId;
  String? completedOn;
  String? confirmTXHash;
  String currency;
  String listingId;
  double listingPrice;
  int purchaseId;
  String sellerId;
  int status;
  String txHash;

  PurchaseListing({
    required this.artwork,
    required this.buyerId,
    this.completedOn,
    this.confirmTXHash,
    required this.currency,
    required this.listingId,
    required this.listingPrice,
    required this.purchaseId,
    required this.sellerId,
    required this.txHash,
    required this.status,
  });

  factory PurchaseListing.fromJson(Map<String, dynamic> json) {
    return PurchaseListing(
      artwork: new Artwork.fromMap(json['artwork']),
      buyerId: json['buyer_id'],
      completedOn: json['completed_on'],
      confirmTXHash: json['confirm_tx_hash'],
      currency: json['currency'],
      listingId: json['listing_id'],
      listingPrice: json['listing_price'],
      purchaseId: json['purchase_id'],
      sellerId: json['seller_id'],
      txHash: json['tx_hash'],
      status: json['status'],
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artwork'] = this.artwork.toJson();
    data['buyer_id'] = this.buyerId;
    data['completed_on'] = this.completedOn;
    data['confirm_tx_hash'] = this.confirmTXHash;
    data['currency'] = this.currency;
    data['listing_id'] = this.listingId;
    data['listing_price'] = this.listingPrice;
    data['purchase_id'] = this.purchaseId;
    data['seller_id'] = this.sellerId;
    data['tx_hash'] = this.txHash;
    data['status'] = this.status;

    return data;
  }
}

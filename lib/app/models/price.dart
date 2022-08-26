class Price {
  double amount;
  String currency;
  String? listingId;
  int? priceId;

  Price(
      {required this.amount,
      required this.currency,
      this.listingId,
      this.priceId});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: json['amount'],
      currency: json['currency'],
      listingId: json['listing_id'],
      priceId: json['price_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['listing_id'] = this.listingId;
    data['price_id'] = this.priceId;
    return data;
  }
}

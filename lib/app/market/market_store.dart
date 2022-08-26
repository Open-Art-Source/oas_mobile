import 'package:mobx/mobx.dart';
import 'package:oas_mobile/app/models/market_listing.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';

// Include generated file
part 'market_store.g.dart';

// This is the class used by rest of your codebase
class MarketStore extends _MarketStore with _$MarketStore {
  MarketStore(OasServerApis oasServerApis) {
    super.oasServerApis = oasServerApis;
    load();
  }
}

// The store-class
abstract class _MarketStore with Store {
  OasServerApis? oasServerApis;

  // ready to be purchased
  @observable
  List<MarketListing> readyListings = [];

  @observable
  List<MarketListing> allListings = [];

  @action
  Future<void> load() async {
    allListings = await oasServerApis!.getListings();
    readyListings = allListings.where( (l) => l.status == 0 ).cast<MarketListing>().toList();
  }
}
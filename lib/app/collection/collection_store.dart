import 'package:mobx/mobx.dart';
import 'package:oas_mobile/app/models/purchaseListing.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';
import 'package:oas_mobile/app/services/stx_oas_server_apis.dart';

// Include generated file
part 'collection_store.g.dart';

// This is the class used by rest of your codebase
class CollectionStore extends _CollectionStore with _$CollectionStore {
  CollectionStore(
      OasServerApis oasServerApis, STXOasServerApis stxOasServerApis) {
    super.oasServerApis = oasServerApis;
    super.stxOasServerApis = stxOasServerApis;
    load();
  }
}

// The store-class
abstract class _CollectionStore with Store {
  OasServerApis? oasServerApis;
  STXOasServerApis? stxOasServerApis;

  // status = 2 -- purchased but pending
  @observable
  List<PurchaseListing> pendingListings = [];

  // status = 5 -- purchase complete
  @observable
  List<PurchaseListing> completeListings = [];

  @observable
  List<PurchaseListing> allListings = [];

  @action
  Future<void> load() async {
    allListings = await oasServerApis!.getPurchases(false);
    for (PurchaseListing eachPurchase in allListings) {
      if (eachPurchase.status != 5) {
        stxOasServerApis!.checkPurchase(
            eachPurchase.artwork.artworkId!, eachPurchase.currency);
        stxOasServerApis!.checkConfirmPurchase(eachPurchase.artwork.artworkId!);
      }
    }
    pendingListings = allListings
        .where((l) => l.status == 2 || l.status == 1 || l.status == 4)
        .cast<PurchaseListing>()
        .toList();
    completeListings = allListings.where((l) => l.status == 5).cast<PurchaseListing>().toList();
  }

  @action
  Future<void> reloadPending(List<PurchaseListing> list) async {
    pendingListings = list;
  }

  @action
  Future<void> reloadComplete(List<PurchaseListing> list) async {
    completeListings = list;
  }
}

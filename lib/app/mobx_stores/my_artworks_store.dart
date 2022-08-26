import 'package:mobx/mobx.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/services/oas_server_apis.dart';

// Include generated file
part 'my_artworks_store.g.dart';

// This is the class used by rest of your codebase
class MyArtworksStore extends _MyArtworksStore with _$MyArtworksStore {
  MyArtworksStore(OasServerApis oasServerApis) {
    super.oasServerApis = oasServerApis;
    load();
  }
}

// The store-class
abstract class _MyArtworksStore with Store {
  OasServerApis? oasServerApis;

  @observable
  List<Artwork> myArtworks = [];

  @action
  Future<void> load() async {
    myArtworks = await oasServerApis!.getMyArtworks();
  }
}
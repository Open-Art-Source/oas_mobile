import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oas_mobile/app/models/artwork.dart';
import 'package:oas_mobile/app/services/ifps_service.dart';
import 'package:oas_mobile/wallet_connect/walletconnect.dart';

// Include generated file
part 'edit_artwork_store.g.dart';

// This is the class used by rest of your codebase
class EditArtworkStore extends _EditArtworkStore with _$EditArtworkStore {
  EditArtworkStore(Artwork? artwork) {
    super.artwork = artwork;
    bool check = artwork != null && artwork.stxContractAddress != null;
    this.setMintOnce(check);
    bool minted = artwork != null && artwork.stxTokenId != null;
    this.setMinted(minted);
    if (artwork?.imageFilesHash != null) {
      loadImagesFromIpfs();
    }
  }
}

// The store-class
abstract class _EditArtworkStore with Store, ImagesFromIfps {
  Artwork? artwork;
  WCSession? wcSession;

  @observable
  ObservableFuture<List<Widget>>? imagesFromIpfs;

  @observable
  ObservableFuture<Widget>? primaryImageFromIpfs;

  @observable
  List<Asset>? imagesFromPicker;

  @observable
  bool walletConnection = false;

  @observable
  bool mintOnce = false;

  @observable
  bool minted = false;

  @computed
  ObservableFuture<List<Widget>> get artworkImages {
    if (imagesFromPicker != null) {
      List<Widget> images = imagesFromPicker!
          .map((asset) => AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ))
          .toList();

      return Future<List<Widget>>.value(images).asObservable();
    } else if (imagesFromIpfs != null) {
      return imagesFromIpfs!;
    } else {
      return Future<List<Widget>>.value([]).asObservable();
    }
  }

  @action
  void setImagesFromPicker(List<Asset> images) {
    imagesFromPicker = images;
  }

  @action
  Future<void> loadImagesFromIpfs() async {
    imagesFromIpfs = allThumbs.asObservable();
  }

  @action
  void setConnection(bool connection) {
    walletConnection = connection;
  }

  @action
  void setMintOnce(bool v) {
    mintOnce = v;
  }

  @action
  void setMinted(bool v) {
    minted = v;
  }
}

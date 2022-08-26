// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_artwork_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EditArtworkStore on _EditArtworkStore, Store {
  Computed<ObservableFuture<List<Widget>>>? _$artworkImagesComputed;

  @override
  ObservableFuture<List<Widget>> get artworkImages =>
      (_$artworkImagesComputed ??= Computed<ObservableFuture<List<Widget>>>(
              () => super.artworkImages,
              name: '_EditArtworkStore.artworkImages'))
          .value;

  final _$imagesFromIpfsAtom = Atom(name: '_EditArtworkStore.imagesFromIpfs');

  @override
  ObservableFuture<List<Widget>>? get imagesFromIpfs {
    _$imagesFromIpfsAtom.reportRead();
    return super.imagesFromIpfs;
  }

  @override
  set imagesFromIpfs(ObservableFuture<List<Widget>>? value) {
    _$imagesFromIpfsAtom.reportWrite(value, super.imagesFromIpfs, () {
      super.imagesFromIpfs = value;
    });
  }

  final _$primaryImageFromIpfsAtom =
      Atom(name: '_EditArtworkStore.primaryImageFromIpfs');

  @override
  ObservableFuture<Widget>? get primaryImageFromIpfs {
    _$primaryImageFromIpfsAtom.reportRead();
    return super.primaryImageFromIpfs;
  }

  @override
  set primaryImageFromIpfs(ObservableFuture<Widget>? value) {
    _$primaryImageFromIpfsAtom.reportWrite(value, super.primaryImageFromIpfs,
        () {
      super.primaryImageFromIpfs = value;
    });
  }

  final _$imagesFromPickerAtom =
      Atom(name: '_EditArtworkStore.imagesFromPicker');

  @override
  List<Asset>? get imagesFromPicker {
    _$imagesFromPickerAtom.reportRead();
    return super.imagesFromPicker;
  }

  @override
  set imagesFromPicker(List<Asset>? value) {
    _$imagesFromPickerAtom.reportWrite(value, super.imagesFromPicker, () {
      super.imagesFromPicker = value;
    });
  }

  final _$walletConnectionAtom =
      Atom(name: '_EditArtworkStore.walletConnection');

  @override
  bool get walletConnection {
    _$walletConnectionAtom.reportRead();
    return super.walletConnection;
  }

  @override
  set walletConnection(bool value) {
    _$walletConnectionAtom.reportWrite(value, super.walletConnection, () {
      super.walletConnection = value;
    });
  }

  final _$mintOnceAtom = Atom(name: '_EditArtworkStore.mintOnce');

  @override
  bool get mintOnce {
    _$mintOnceAtom.reportRead();
    return super.mintOnce;
  }

  @override
  set mintOnce(bool value) {
    _$mintOnceAtom.reportWrite(value, super.mintOnce, () {
      super.mintOnce = value;
    });
  }

  final _$mintedAtom = Atom(name: '_EditArtworkStore.minted');

  @override
  bool get minted {
    _$mintedAtom.reportRead();
    return super.minted;
  }

  @override
  set minted(bool value) {
    _$mintedAtom.reportWrite(value, super.minted, () {
      super.minted = value;
    });
  }

  final _$loadImagesFromIpfsAsyncAction =
      AsyncAction('_EditArtworkStore.loadImagesFromIpfs');

  @override
  Future<void> loadImagesFromIpfs() {
    return _$loadImagesFromIpfsAsyncAction
        .run(() => super.loadImagesFromIpfs());
  }

  final _$_EditArtworkStoreActionController =
      ActionController(name: '_EditArtworkStore');

  @override
  void setImagesFromPicker(List<Asset> images) {
    final _$actionInfo = _$_EditArtworkStoreActionController.startAction(
        name: '_EditArtworkStore.setImagesFromPicker');
    try {
      return super.setImagesFromPicker(images);
    } finally {
      _$_EditArtworkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConnection(bool connection) {
    final _$actionInfo = _$_EditArtworkStoreActionController.startAction(
        name: '_EditArtworkStore.setConnection');
    try {
      return super.setConnection(connection);
    } finally {
      _$_EditArtworkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMintOnce(bool v) {
    final _$actionInfo = _$_EditArtworkStoreActionController.startAction(
        name: '_EditArtworkStore.setMintOnce');
    try {
      return super.setMintOnce(v);
    } finally {
      _$_EditArtworkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMinted(bool v) {
    final _$actionInfo = _$_EditArtworkStoreActionController.startAction(
        name: '_EditArtworkStore.setMinted');
    try {
      return super.setMinted(v);
    } finally {
      _$_EditArtworkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
imagesFromIpfs: ${imagesFromIpfs},
primaryImageFromIpfs: ${primaryImageFromIpfs},
imagesFromPicker: ${imagesFromPicker},
walletConnection: ${walletConnection},
mintOnce: ${mintOnce},
minted: ${minted},
artworkImages: ${artworkImages}
    ''';
  }
}

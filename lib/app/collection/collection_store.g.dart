// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CollectionStore on _CollectionStore, Store {
  final _$pendingListingsAtom = Atom(name: '_CollectionStore.pendingListings');

  @override
  List<PurchaseListing> get pendingListings {
    _$pendingListingsAtom.reportRead();
    return super.pendingListings;
  }

  @override
  set pendingListings(List<PurchaseListing> value) {
    _$pendingListingsAtom.reportWrite(value, super.pendingListings, () {
      super.pendingListings = value;
    });
  }

  final _$completeListingsAtom =
      Atom(name: '_CollectionStore.completeListings');

  @override
  List<PurchaseListing> get completeListings {
    _$completeListingsAtom.reportRead();
    return super.completeListings;
  }

  @override
  set completeListings(List<PurchaseListing> value) {
    _$completeListingsAtom.reportWrite(value, super.completeListings, () {
      super.completeListings = value;
    });
  }

  final _$allListingsAtom = Atom(name: '_CollectionStore.allListings');

  @override
  List<PurchaseListing> get allListings {
    _$allListingsAtom.reportRead();
    return super.allListings;
  }

  @override
  set allListings(List<PurchaseListing> value) {
    _$allListingsAtom.reportWrite(value, super.allListings, () {
      super.allListings = value;
    });
  }

  final _$loadAsyncAction = AsyncAction('_CollectionStore.load');

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  final _$reloadPendingAsyncAction =
      AsyncAction('_CollectionStore.reloadPending');

  @override
  Future<void> reloadPending(List<PurchaseListing> list) {
    return _$reloadPendingAsyncAction.run(() => super.reloadPending(list));
  }

  final _$reloadCompleteAsyncAction =
      AsyncAction('_CollectionStore.reloadComplete');

  @override
  Future<void> reloadComplete(List<PurchaseListing> list) {
    return _$reloadCompleteAsyncAction.run(() => super.reloadComplete(list));
  }

  @override
  String toString() {
    return '''
pendingListings: ${pendingListings},
completeListings: ${completeListings},
allListings: ${allListings}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MarketStore on _MarketStore, Store {
  final _$readyListingsAtom = Atom(name: '_MarketStore.readyListings');

  @override
  List<MarketListing> get readyListings {
    _$readyListingsAtom.reportRead();
    return super.readyListings;
  }

  @override
  set readyListings(List<MarketListing> value) {
    _$readyListingsAtom.reportWrite(value, super.readyListings, () {
      super.readyListings = value;
    });
  }

  final _$allListingsAtom = Atom(name: '_MarketStore.allListings');

  @override
  List<MarketListing> get allListings {
    _$allListingsAtom.reportRead();
    return super.allListings;
  }

  @override
  set allListings(List<MarketListing> value) {
    _$allListingsAtom.reportWrite(value, super.allListings, () {
      super.allListings = value;
    });
  }

  final _$loadAsyncAction = AsyncAction('_MarketStore.load');

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
readyListings: ${readyListings},
allListings: ${allListings}
    ''';
  }
}

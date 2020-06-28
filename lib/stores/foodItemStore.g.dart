// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foodItemStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FoodItemStore on _FoodItemStore, Store {
  final _$foodItemsListAtom = Atom(name: '_FoodItemStore.foodItemsList');

  @override
  List<FoodItemsModel> get foodItemsList {
    _$foodItemsListAtom.reportRead();
    return super.foodItemsList;
  }

  @override
  set foodItemsList(List<FoodItemsModel> value) {
    _$foodItemsListAtom.reportWrite(value, super.foodItemsList, () {
      super.foodItemsList = value;
    });
  }

  final _$fooditemsObjectAtom = Atom(name: '_FoodItemStore.fooditemsObject');

  @override
  FoodItemsModel get fooditemsObject {
    _$fooditemsObjectAtom.reportRead();
    return super.fooditemsObject;
  }

  @override
  set fooditemsObject(FoodItemsModel value) {
    _$fooditemsObjectAtom.reportWrite(value, super.fooditemsObject, () {
      super.fooditemsObject = value;
    });
  }

  final _$checkoutItemsAtom = Atom(name: '_FoodItemStore.checkoutItems');

  @override
  List<CategoryDishes> get checkoutItems {
    _$checkoutItemsAtom.reportRead();
    return super.checkoutItems;
  }

  @override
  set checkoutItems(List<CategoryDishes> value) {
    _$checkoutItemsAtom.reportWrite(value, super.checkoutItems, () {
      super.checkoutItems = value;
    });
  }

  final _$itemsCountAtom = Atom(name: '_FoodItemStore.itemsCount');

  @override
  int get itemsCount {
    _$itemsCountAtom.reportRead();
    return super.itemsCount;
  }

  @override
  set itemsCount(int value) {
    _$itemsCountAtom.reportWrite(value, super.itemsCount, () {
      super.itemsCount = value;
    });
  }

  final _$subTotalCountAtom = Atom(name: '_FoodItemStore.subTotalCount');

  @override
  int get subTotalCount {
    _$subTotalCountAtom.reportRead();
    return super.subTotalCount;
  }

  @override
  set subTotalCount(int value) {
    _$subTotalCountAtom.reportWrite(value, super.subTotalCount, () {
      super.subTotalCount = value;
    });
  }

  final _$getFoodItemsAsyncAction = AsyncAction('_FoodItemStore.getFoodItems');

  @override
  Future<List<FoodItemsModel>> getFoodItems() {
    return _$getFoodItemsAsyncAction.run(() => super.getFoodItems());
  }

  final _$_FoodItemStoreActionController =
      ActionController(name: '_FoodItemStore');

  @override
  void clearData() {
    final _$actionInfo = _$_FoodItemStoreActionController.startAction(
        name: '_FoodItemStore.clearData');
    try {
      return super.clearData();
    } finally {
      _$_FoodItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getItemsCount() {
    final _$actionInfo = _$_FoodItemStoreActionController.startAction(
        name: '_FoodItemStore.getItemsCount');
    try {
      return super.getItemsCount();
    } finally {
      _$_FoodItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getSubTotalPrice() {
    final _$actionInfo = _$_FoodItemStoreActionController.startAction(
        name: '_FoodItemStore.getSubTotalPrice');
    try {
      return super.getSubTotalPrice();
    } finally {
      _$_FoodItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementAction(
      String actionType, int dishCount, int index, int selectedMenuIndex) {
    final _$actionInfo = _$_FoodItemStoreActionController.startAction(
        name: '_FoodItemStore.incrementAction');
    try {
      return super
          .incrementAction(actionType, dishCount, index, selectedMenuIndex);
    } finally {
      _$_FoodItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementAction(
      String actionType, int dishCount, int index, int selectedMenuIndex) {
    final _$actionInfo = _$_FoodItemStoreActionController.startAction(
        name: '_FoodItemStore.decrementAction');
    try {
      return super
          .decrementAction(actionType, dishCount, index, selectedMenuIndex);
    } finally {
      _$_FoodItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cartIncrementDecrementAction(String actionType, int index) {
    final _$actionInfo = _$_FoodItemStoreActionController.startAction(
        name: '_FoodItemStore.cartIncrementDecrementAction');
    try {
      return super.cartIncrementDecrementAction(actionType, index);
    } finally {
      _$_FoodItemStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
foodItemsList: ${foodItemsList},
fooditemsObject: ${fooditemsObject},
checkoutItems: ${checkoutItems},
itemsCount: ${itemsCount},
subTotalCount: ${subTotalCount}
    ''';
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kochicart/models/foodItemsModel.dart';
import 'package:mobx/mobx.dart';

part 'foodItemStore.g.dart';

class FoodItemStore = _FoodItemStore with _$FoodItemStore;

// ignore: camel_case_types
abstract class _FoodItemStore with Store {
  @observable
  List<FoodItemsModel> foodItemsList = [];
  @observable
  FoodItemsModel fooditemsObject = FoodItemsModel();
  // @Observable
  // CategoryDishes categoryDishes = CategoryDishes();

  @observable
  List<CategoryDishes> checkoutItems = [];

  @observable
  int itemsCount = 0;

  @observable
  int subTotalCount = 0;

  @action
  void clearData() {
    checkoutItems = [];
    foodItemsList = [];
    getFoodItems();
  }

  @observable
  bool loaderVisibility = false;
  @action
  Future<List<FoodItemsModel>> getFoodItems() async {
    print("how many times");
    loaderVisibility = true;
    String url = 'https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad';
    Response response = await get(url);
    // sample info available in response
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      print("response json $statusCode");

      String json = response.body;
      print(json);

      foodItemsList = (jsonDecode(json) as List)
          .map((e) => new FoodItemsModel.fromJson(e))
          .toList();

      return foodItemsList;
    }
    loaderVisibility = false;
    return foodItemsList;
  }

  @action
  void getItemsCount() {
    var totalCount = 0;
    print(this.checkoutItems.length);
    print("0000000");
    for (var item in checkoutItems) {
      print(item.count);
      totalCount = totalCount + item.count;
    }

    print("items are $totalCount");
    itemsCount = totalCount;
  }

  @action
  void getSubTotalPrice() {
    var subTotal = 0;
    for (var item in checkoutItems) {
      var tempTotal = item.count * item.dishPrice.toInt();

      subTotal = subTotal + tempTotal;
      print("items are each ");
      print(subTotal);
    }
    subTotalCount = subTotal;
  }

  @action
  void incrementAction(
      String actionType, int dishCount, int index, int selectedMenuIndex) {
    List<FoodItemsModel> fooditems = this.foodItemsList;
    CategoryDishes catDish =
        fooditems[0].tableMenuList[selectedMenuIndex].categoryDishes[index];

    fooditems[0].tableMenuList[selectedMenuIndex].categoryDishes[index].count =
        dishCount + 1;

    fooditems[0]
        .tableMenuList[selectedMenuIndex]
        .categoryDishes[index]
        .dishTotalItemsPrice = (dishCount + 1) * catDish.dishPrice;

    this.foodItemsList = fooditems;

    cartItems(
        fooditems[0].tableMenuList[selectedMenuIndex].categoryDishes[index],
        "adding");
  }

  @action
  void decrementAction(
      String actionType, int dishCount, int index, int selectedMenuIndex) {
    List<FoodItemsModel> fooditems = this.foodItemsList;

    CategoryDishes catDish =
        fooditems[0].tableMenuList[selectedMenuIndex].categoryDishes[index];

    if (dishCount != 0) {
      fooditems[0]
          .tableMenuList[selectedMenuIndex]
          .categoryDishes[index]
          .count = dishCount - 1;

      fooditems[0]
          .tableMenuList[selectedMenuIndex]
          .categoryDishes[index]
          .dishTotalItemsPrice = (dishCount - 1) * catDish.dishPrice;

      this.foodItemsList = fooditems;
    }

    cartItems(
        fooditems[0].tableMenuList[selectedMenuIndex].categoryDishes[index],
        "deleting");
  }

  @action
  void cartIncrementDecrementAction(String actionType, int index) {
    List<CategoryDishes> tempDishesList = checkoutItems;
    if (actionType == "Increment") {
      print("hiii i am incremented $index");
      tempDishesList[index].count = checkoutItems[index].count + 1;
      tempDishesList[index].dishTotalItemsPrice =
          (tempDishesList[index].count) * checkoutItems[index].dishPrice;

      checkoutItems = tempDishesList;
    } else if (actionType == "Decrement") {
      print("hiii i am decremented $index");
      if (checkoutItems[index].count > 0) {
        tempDishesList[index].count = checkoutItems[index].count - 1;

        tempDishesList[index].dishTotalItemsPrice =
            (tempDishesList[index].count) * checkoutItems[index].dishPrice;
        if (checkoutItems[index].count == 0) {
          tempDishesList.remove(tempDishesList[index]);
        }
        checkoutItems = tempDishesList;
        if (checkoutItems.length == 0) {
          clearData();
        }
      } else {
        tempDishesList.remove(tempDishesList[index]);
        checkoutItems = tempDishesList;
      }
    }
  }

  // @action
  void cartItems(CategoryDishes categoryDish, String operationType) {
    //for (var item in checkoutItems) {
    List<CategoryDishes> list = checkoutItems;

    if (operationType == "adding") {
      if (checkoutItems.isEmpty) {
        list.add(categoryDish);
      } else {
        for (var i = 0; i < checkoutItems.length; i++) {
          if (checkoutItems[i].dishId == categoryDish.dishId) {
            list[i] = categoryDish;
          } else {
            if (!checkoutItems.contains(categoryDish)) {
              list.add(categoryDish);
            }
          }
        }
      }
    } else {
      if (checkoutItems.isEmpty) {
        list = [];
      } else {
        for (var i = 0; i < checkoutItems.length; i++) {
          if (checkoutItems[i].dishId == categoryDish.dishId) {
            if (categoryDish.count == 0) {
              list.remove(categoryDish);
            } else {
              list[i] = categoryDish;
            }
          } else {
            if (checkoutItems.contains(categoryDish)) {
              if (categoryDish.count == 0) {
                list.remove(categoryDish);
              }
            }
          }
        }
      }
    }

    this.checkoutItems = list; // here items are updating to cart

    print("checkout items length");
    print(checkoutItems.length);
  }
}

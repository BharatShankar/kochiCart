import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kochicart/CheckoutScreen.dart';
import 'package:kochicart/SideMenu.dart';
import 'package:kochicart/constants/Constants.dart';
import 'package:kochicart/models/foodItemsModel.dart';
import 'package:kochicart/stores/foodItemStore.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> listArray = [
    "Catogory of food",
    "italian",
    "Russina takilas",
    "Chineese",
    "Mangolian masala"
  ];
  var foodItemTitle = "";

  int selectedMenuIndex = 0;
  @override
  void initState() {
    fooditemStore.getFoodItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        actions: <Widget>[
          _shoppingCartBadge(),
        ],
        // actions: <Widget>[
        //   FlatButton(
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(Constants.ROUTE_CHECKOUT);
        //     },
        //     child: Text("data"),
        //   ),
        // ],
      ),
      body: bodyWidget(),
    );
  }

  Widget _shoppingCartBadge() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Observer(builder: (_) {
        return Container(
            // height: 150.0,
            // width: 30.0,
            child: new GestureDetector(
          onTap: () {
            print("-------");
            print(fooditemStore.checkoutItems.length);
            Navigator.of(context).pushNamed(Constants.ROUTE_CHECKOUT);
          },
          child: new Stack(
            children: <Widget>[
              new IconButton(
                icon: new Icon(
                  Icons.shopping_cart,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: null,
              ),
              /*list.length*/ fooditemStore.checkoutItems.length == 0
                  ? new Container()
                  : new Positioned(
                      child: new Stack(
                      children: <Widget>[
                        new Icon(Icons.brightness_1,
                            size: 25.0, color: Colors.red[300]),
                        new Positioned(
                            top: 5.0,
                            left: 8.0,
                            child: new Text(
                              fooditemStore?.checkoutItems?.length.toString(),
                              //list.length.toString(),
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    )),
            ],
          ),
        ));
      }),
    );
  }

  Widget bodyWidget() {
    return Container(
      child: Column(children: <Widget>[
        Container(
          height: 60,
          color: Colors.white,
          child: categoriesView(),
        ),
        Expanded(
          child: Observer(builder: (_) {
            List<CategoryDishes> categoryDishes = [];
            if (fooditemStore.foodItemsList.isNotEmpty) {
              categoryDishes = fooditemStore?.foodItemsList[0]
                  ?.tableMenuList[selectedMenuIndex].categoryDishes;
            }
            return Container(
              child: ListView.builder(
                itemCount: categoryDishes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Container(
                      decoration: getRoundedCorneres(
                          backgroundColor: Colors.white, circleValue: 10.0),
                      //height: 50,
                      child: listViewRow(context, categoryDishes[index], index),
                    ),
                  );
                },
              ),
            );
          }),
        )
      ]),
    );
  }

  Widget footerWidget() {
    return Container();
  }

  Widget listViewRow(BuildContext context, CategoryDishes dish, int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          productType(context, dish),
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 5, top: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  productTitle(context, dish),
                  costAndCalories(context, dish),
                  productDescription(context, dish),
                  addOrDeleteView(context, dish, index),
                  anyCustomization(context, dish),
                ],
              ),
            ),
          ),
          productImage(context, dish),
        ],
      ),
    );
  }

  Widget productType(BuildContext context, CategoryDishes dish) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 15),
      child: Image.asset(
        dish.dishType != 1
            ? 'assets/images/veg.png'
            : 'assets/images/non_veg.png',
        height: 22,
        width: 22,
      ),
    );
  }

  Widget productImage(BuildContext context, CategoryDishes dish) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.23,
        height: 100,
        child: dish?.dishImage != null
            ? Container(
                decoration: getRoundedCorneres(
                    backgroundColor: Colors.white, circleValue: 10.0),
                child: Image.network(
                  dish?.dishImage,
                  fit: BoxFit.fill,
                ),
              )
            : Container(
                decoration: getRoundedCorneres(
                    backgroundColor: Colors.white, circleValue: 10.0),
                child: Image.asset(
                  'assets/images/italian.jpg',
                  fit: BoxFit.fill,
                ),
              ),
        // Image.asset(
        //   'assets/images/italian.jpg',
        //   fit: BoxFit.fill,
        // ),
      ),
    ); //Image.asset('images/italian.png',height: 100,width: 100,);
  }

  Widget productTitle(BuildContext context, CategoryDishes dish) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, right: 5),
      child: Text(
        dish?.dishName ?? "N/A",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF393939)),
      ),
    );
  }

  Widget costAndCalories(BuildContext context, CategoryDishes dish) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, bottom: 10, top: 5, left: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              dish?.dishPrice?.toString() != null
                  ? "SAR " + dish?.dishPrice?.toString()
                  : "N/A",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey[850])),
          Text(
              dish?.dishCalories?.toString() != null
                  ? dish.dishCalories.toString() + " Calories"
                  : "N/A",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.grey[850])),
        ],
      ),
    );
    // );
  }

  Widget productDescription(BuildContext context, CategoryDishes dish) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 5, bottom: 15),
      child: Text(dish?.dishDescription ?? "N/A",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF989898))),
    );
  }

  Widget addOrDeleteView(BuildContext context, CategoryDishes dish, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        height: 44,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: getRoundedCorneres(
            backgroundColor: Colors.green[900], circleValue: 22.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Minus Action
            IconButton(
                onPressed: () {
                  print("minus button pressed");
                  // Navigator.of(context)
                  //     .pushNamed(Constants.ROUTE_CHECKOUT)
                  //     .then((value) {
                  //   print("this is viewwill appear $value");
                  // });
                  fooditemStore.decrementAction(
                      "INCREMENT", dish.count, index, selectedMenuIndex);
                },
                icon: Icon(Icons.remove, color: Colors.white)),
            Observer(builder: (_) {
              List<CategoryDishes> categoryDishes = [];
              if (fooditemStore.foodItemsList.isNotEmpty) {
                categoryDishes = fooditemStore?.foodItemsList[0]
                    ?.tableMenuList[selectedMenuIndex].categoryDishes;
              }
              return Text("${categoryDishes[index].count}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[300]));
            }),
            // Plus Action
            IconButton(
                onPressed: () {
                  fooditemStore.incrementAction(
                      "INCREMENT", dish.count, index, selectedMenuIndex);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  Widget anyCustomization(BuildContext context, CategoryDishes dish) {
    return dish.addonCat.length == 0
        ? Container()
        : FlatButton(
            padding: EdgeInsets.all(0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {},
            child: Text("Customizations available",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.red[300])),
          );
  }

  Widget categoriesView() {
    return Observer(builder: (_) {
      print("d d d d d d ${fooditemStore.foodItemsList.length}");
      List<TableMenuList> tableMenu = [];
      if (fooditemStore.foodItemsList.isNotEmpty) {
        tableMenu = fooditemStore?.foodItemsList[0]?.tableMenuList;
      }

      return ListView.builder(
        itemCount: tableMenu.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    selectedMenuIndex = index;
                    setState(() {});
                  },
                  child: new Column(
                    children: <Widget>[
                      Text(tableMenu[index].menuCategory,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: selectedMenuIndex == index
                                  ? Colors.red
                                  : Colors.grey)),
                      Container(
                        height: 2,
                        color: Colors.red,
                      )
                    ],
                  )),
              // Container(
              //   height: 2,
              //   color:  Colors.red,//selectedMenuIndex == index ? Colors.red : Colors.transparent,
              //   ),
            ],
          );
        },
        scrollDirection: Axis.horizontal,
      );
    });
  }

  Widget foodItemsListView() {
    return Container();
  }

  BoxDecoration getRoundedCorneres(
      {backgroundColor: Color, circleValue: Float}) {
    return BoxDecoration(
      color: backgroundColor,
      boxShadow: [
        BoxShadow(blurRadius: 10, color: Colors.grey[350], offset: Offset(1, 3))
      ],
      borderRadius: BorderRadius.all(Radius.circular(circleValue)),
    );
  }
}

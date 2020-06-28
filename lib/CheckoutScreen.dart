import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kochicart/HomePage.dart';
import 'package:kochicart/constants/Constants.dart';
import 'package:kochicart/main.dart';
import 'package:kochicart/stores/foodItemStore.dart';

// import 'stores/foodItemStore.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    fooditemStore.getItemsCount();
    fooditemStore.getSubTotalPrice();
    super.initState();
    print(
        "listview items count starting ${fooditemStore?.checkoutItems?.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary"),
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            dishesView(context),
            placeOrderButton(context),
          ],
        ),
      )),
    );
  }

  Widget numOfItems(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        onPressed: () {},
        color: Colors.green[900],
        child: Observer(builder: (_) {
          return Text(
            "${fooditemStore?.checkoutItems?.length ?? 0} Dishes - ${fooditemStore.itemsCount} Items",
            //"2 Dishes - 2 Items",
            style: TextStyle(
              color: Colors.white,
              //fontFamily: 'Raleway',
              fontSize: 22.0,
            ),
          );
        }),
      ),
    );
  }

  Widget placeOrderButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          onPressed: () {
            if (fooditemStore?.checkoutItems?.length == 0) {
              Fluttertoast.showToast(
                msg: "No items in cart",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            } else {
              _showDialog();
            }
          },
          color: Colors.green[900],
          child: Text(
            "Place order",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              //fontFamily: 'Raleway',
              fontSize: 22.0,
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Congratulations"),
          content: new Text("Order successfully placed"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                fooditemStore.clearData();
                Navigator.popUntil(
                    context, ModalRoute.withName(Constants.ROUTE_HOME));
              },
            ),
          ],
        );
      },
    );
  }

  Widget dishesView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: getRoundedCorneres(
            backgroundColor: Colors.white, circleValue: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              numOfItems(context),
              itemsList(context),
              totalAmountView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemsList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 4.0, right: 4.0, top: 20, bottom: 10),
        child: Observer(builder: (_) {
          print("listview items count${fooditemStore.checkoutItems.length}");
          return ListView.builder(
            itemCount: fooditemStore.checkoutItems.length,
            itemBuilder: (context, index) {
              return Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/veg.png',
                      height: 22,
                      width: 22,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              fooditemStore?.checkoutItems[index]?.dishName ??
                                  "N/A",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff393939),
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, top: 8, bottom: 8, right: 8),
                              child: Text(
                                "INR " +
                                        fooditemStore
                                            ?.checkoutItems[index]?.dishPrice
                                            .toString() ??
                                    "N/A",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff393939),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                fooditemStore
                                            ?.checkoutItems[index]?.dishCalories
                                            .toString() +
                                        " Calories" ??
                                    "N/A" + " Calories",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff393939),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: <Widget>[
                                // remove action
                                IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      fooditemStore
                                          .cartIncrementDecrementAction(
                                              "Decrement", index);
                                      fooditemStore.getSubTotalPrice();
                                      fooditemStore.getItemsCount();
                                    }),
                                Text(
                                  fooditemStore?.checkoutItems[index]?.count
                                          ?.toString() ??
                                      "N/A",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                                // add action
                                IconButton(
                                    icon: Icon(Icons.add, color: Colors.white),
                                    onPressed: () {
                                      fooditemStore
                                          .cartIncrementDecrementAction(
                                              "Increment", index);
                                      fooditemStore.getSubTotalPrice();
                                      fooditemStore.getItemsCount();
                                    })
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "INR " +
                                      fooditemStore?.checkoutItems[index]
                                          ?.dishTotalItemsPrice
                                          .toString() ??
                                  "N/A",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff393939)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget totalAmountView(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Container(height: 1, color: Colors.grey),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total Amount",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff393939)),
              ),
              Observer(builder: (_) {
                return Text(
                  "INR " + fooditemStore.subTotalCount.toString() + ".00",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green[700]),
                );
              }),
            ],
          ),
        ],
      ),
    ));
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

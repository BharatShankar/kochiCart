import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kochicart/constants/Constants.dart';
import 'package:kochicart/models/foodItemsModel.dart';
import 'package:kochicart/remainderDetails.dart';
import 'package:kochicart/stores/foodItemStore.dart';
import 'package:kochicart/swipe_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    // fooditemStore.getFoodItems();
    remainderStore.getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        // actions: <Widget>[
        //   _shoppingCartBadge(),
        // ],
      ),
      body: bodyWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          print("add button pressed");
          // Navigator.of(context)
          //     .pushNamed(Constants.ROUTE_REMAINDER)
          //     .then((value) => () {
          //           if (value == true) {
          //             print("then called now");
          //           }
          //         });

          Navigator.of(context)
              .pushNamed(Constants.ROUTE_REMAINDER)
              .then((results) {
            print("then called now");
            remainderStore.getCount();
            setState(() {});
          });
        },
        label: Text('Add'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget bodyWidget() {
    return Observer(builder: (_) {
      return Container(
        child: Column(children: <Widget>[
          Expanded(
            child:
                // Observer(builder: (_) {
                //   return
                Container(
              child: ListView.builder(
                itemCount: remainderStore.listOfRemainders.length,
                itemBuilder: (BuildContext context, int index) {
                  return OnSlide(
                    items: <ActionItems>[
                      new ActionItems(
                          icon: new IconButton(
                            icon: new Icon(Icons.delete),
                            onPressed: () {},
                            color: Colors.red,
                          ),
                          onPress: () {
                            remainderStore.deleteRemainder(index);
                            setState(() {});
                            print("delete button pressed");
                          },
                          backgroudColor: Colors.white),
                      new ActionItems(
                          icon: new IconButton(
                            icon: new Icon(Icons.notifications),
                            onPressed: () {},
                            color: Colors.grey,
                          ),
                          onPress: () {
                            print("notification pressed code here");
                            remainderStore.remainderIndex = index;
                            remainderStore.isRemainderGoEdited = true;
                            Navigator.of(context)
                                .pushNamed(Constants.ROUTE_REMAINDER)
                                .then((results) {
                              print("then called now");
                              remainderStore.getCount();
                              remainderStore.isRemainderGoEdited = false;
                              remainderStore.remainderIndex = -0;
                              setState(() {});
                            });
                            //remainderStore.saveRemainder(remainder);
                          },
                          backgroudColor: Colors.white),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: Container(
                        decoration: getRoundedCorneres(
                            backgroundColor: Colors.white, circleValue: 10.0),
                        //height: 50,
                        child: Row(
                          children: <Widget>[
                            //Date
                            dateCoulm(),
                            //Title and description Column
                            remainderWidget(index),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            //}),
          )
        ]),
      );
    });
  }

  Widget dateCoulm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.brown[100],
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Center(
              child: Text(
                "14",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Apr, 2020",
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget remainderWidget(int index) {
    return Container(
      // color: Colors.blue[100],
      width: MediaQuery.of(context).size.width * 0.67,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(remainderStore.listOfRemainders[index].remainderTitle,
                style: TextStyle(
                    color: Color(0xff393939),
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Text(remainderStore.listOfRemainders[index].remainderDescription)
          ],
        ),
      ),
    );
  }

  Widget footerWidget() {
    return Container();
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

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kochicart/HomePage.dart';
import 'package:kochicart/stores/foodItemStore.dart';
import 'package:date_format/date_format.dart';

import 'main.dart';
import 'models/remainderModel.dart';

class FillRemainderDetails extends StatefulWidget {
  @override
  _FillRemainderDetailsState createState() => _FillRemainderDetailsState();
}

class _FillRemainderDetailsState extends State<FillRemainderDetails> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _date = "Not set";
  String _time = "Not set";
  DateTime mydateTime;
  String editTitle;
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  RemainderData myRemainder;

  @override
  void initState() {
    super.initState();
    editedRemainderData();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  void editedRemainderData() {
    print("selected edited index ${remainderStore.remainderIndex}");
    print(remainderStore.listOfRemainders.length);
    if (remainderStore.remainderIndex != -0) {
      _textController.text = remainderStore
          .listOfRemainders[remainderStore.remainderIndex].remainderTitle;
      _descriptionController.text = remainderStore
          .listOfRemainders[remainderStore.remainderIndex].remainderDescription;

      mydateTime = convertDateFromString(remainderStore
              .listOfRemainders[remainderStore.remainderIndex].dateStr +
          " 00:00:00");
      mydateTime = convertDateFromString('2018-09-27 13:27:00');
      //2018-09-27 13:27:00

      setState(() {});
    }
  }

  DateTime convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    print(todayDate);

    print(formatDate(todayDate,
        [yyyy, '/', mm, '/', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));

    return todayDate;
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    print(mydateTime.day);
    print("this is milli seconds ${mydateTime.millisecond}");
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.schedule(0, 'Manoj gave task',
        'Flutter remainder app to do', mydateTime, platform);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Remainder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: ListView(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              titleOfRemainder(),
              SizedBox(
                height: 12.0,
              ),
              descriptionOfRemainder(),
              SizedBox(
                height: 12.0,
              ),
              datePicker(),
              SizedBox(
                height: 20.0,
              ),
              timePicker(),
              SizedBox(
                height: 25.0,
              ),
              remainderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleOfRemainder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(
              hintText: "Title",
              hintStyle: TextStyle(color: Colors.grey[350]),
              suffixIcon: CircleIconButton(
                onPressed: () {
                  this.setState(() {
                    _textController.clear(); //Clear value
                  });
                },
              )),
        ),
      ),
    );
  }

  Widget descriptionOfRemainder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
              hintText: "Description",
              hintStyle: TextStyle(color: Colors.grey[350]),
              suffixIcon: CircleIconButton(
                onPressed: () {
                  this.setState(() {
                    _descriptionController.clear(); //Clear value
                  });
                },
              )),
        ),
      ),
    );
  }

  Widget datePicker() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: () {
        DateTime initialDatetime = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        DatePicker.showDatePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true,
            onChanged: (curremtDate) {},
            minTime: DateTime.now(),
            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
          mydateTime = date;
          print('confirm $date');
          _date = '${date.year}-${date.month}-${date.day}';
          setState(() {});
        },
            currentTime: remainderStore.remainderIndex != 0
                ? mydateTime
                : initialDatetime,
            locale: LocaleType.en);
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: Colors.teal,
                      ),
                      Text(
                        " $_date",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }

  Widget timePicker() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: () {
        DatePicker.showTimePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (time) {
          print('confirm $time');
          _time = '${time.hour} : ${time.minute} : ${time.second}';
          setState(() {});
        }, currentTime: DateTime.now(), locale: LocaleType.en);
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.teal,
                      ),
                      Text(
                        " $_time",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }

  Widget remainderButton() {
    return Container(
      decoration:
          getRoundedCorneres(backgroundColor: Colors.teal, circleValue: 5.0),
      child: FlatButton(
        onPressed: () {
          showNotification();
          setState(() {});
          if (_date != "Not set" && _time != "Not set") {
            // RemainderData(, _textController.text, _descriptionController.text);

            remainderStore.saveRemainder(RemainderData(_date, _time,
                _textController.text, _descriptionController.text));

            Navigator.pop(context, true);
          } else {
            Fluttertoast.showToast(
                msg: "All fields are required",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: Text(
          "Set Remainder",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
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

class CircleIconButton extends StatelessWidget {
  final double size;
  final Function onPressed;
  final IconData icon;
  CircleIconButton({this.size = 30.0, this.icon = Icons.clear, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.onPressed,
        child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment(0.0, 0.0), // all centered
              children: <Widget>[
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[300]),
                ),
                Icon(
                  icon,
                  size: size * 0.6, // 60% width for icon
                )
              ],
            )));
  }
}

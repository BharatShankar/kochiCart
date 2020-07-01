import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kochicart/HomePage.dart';
import 'package:kochicart/constants/Constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kochicart/remainderDetails.dart';
import 'package:kochicart/stores/user/userDataStore.dart';
import 'package:kochicart/utils/sharedPreferencesHelper.dart';
import 'models/userData.dart';
import 'stores/foodItemStore.dart';

FoodItemStore remainderStore = FoodItemStore();

UserDataStore userDataStore = UserDataStore();
SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // appBarTheme: AppBarTheme(
          //   color: Colors.white,
          // ),
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Colors.white)),
          textTheme: TextTheme(),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(title: ''),
        routes: {
          Constants.ROUTE_HOME: (context) => HomePage(),
          Constants.ROUTE_LOGIN: (context) => LoginPage(),
          Constants.ROUTE_REMAINDER: (context) => FillRemainderDetails(),
        },
        onUnknownRoute: (RouteSettings setting) {
// String unknownRoute = setting.name ;
          return new MaterialPageRoute(builder: (context) => LoginPage());
        });
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Image.asset('assets/images/appicon.png'),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Constants.ROUTE_HOME);
                    },
                    child: Text("Press Me"))
              ],
            ),
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

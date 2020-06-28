import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kochicart/CheckoutScreen.dart';
import 'package:kochicart/HomePage.dart';
import 'package:kochicart/authentication.dart';
import 'package:kochicart/constants/Constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kochicart/phoneSignIn.dart';
import 'package:kochicart/stores/user/userDataStore.dart';
import 'package:kochicart/utils/sharedPreferencesHelper.dart';
import 'models/userData.dart';
import 'stores/foodItemStore.dart';

Authentication auth = Authentication();
FoodItemStore fooditemStore = FoodItemStore();
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
        // theme: ThemeData(
        //     appBarTheme: AppBarTheme(
        //   color: Color(0xFFFFFFFF),
        // )),
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
          primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.grey)),
          textTheme: TextTheme(),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(title: 'Flutter Demo Home Page'),
        routes: {
          Constants.ROUTE_HOME: (context) => HomePage(),
          Constants.ROUTE_CHECKOUT: (context) => CheckoutScreen(),
          Constants.ROUTE_LOGIN: (context) => LoginPage(),
          Constants.ROUTE_PHONE_LOGIN: (context) => PhoneSignInSection(),
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
    checkUserAlreadyLoggedIn();
    super.initState();
  }

  checkUserAlreadyLoggedIn() async {
    final FirebaseUser currentUser = await auth.getCurrentUser();
    if (currentUser?.uid != null) {
      //  UserData userData = await SharedPreferencesHelper().getUserData();
      UserData tempUserData = UserData.fromJson({
        "displayName": currentUser.displayName,
        "email": currentUser.email,
        "photoUrl": currentUser.photoUrl,
        "phoneNumber": currentUser.phoneNumber,
        "providerId": currentUser.providerData[0].providerId
      });
      userDataStore.storeUserData(tempUserData);
      Navigator.pushNamed(context, Constants.ROUTE_HOME);
    } else {
      print("null object -----");
    }
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
                googlButton(context),
                SizedBox(height: 10),
                phoneButton(context),
              ],
            ),
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void googleSignIn(BuildContext context) {
    auth.googlesignIn(context).then((user) {
      if (user != null) {
        print("${user.displayName}");
        UserData tempUserData = UserData.fromJson({
          "displayName": user.displayName,
          "email": user.email,
          "photoUrl": user.photoUrl,
          "providerId": user.providerData[0].providerId,
          "phoneNumber": user.phoneNumber
        });
        print(user.providerId);
        print(user.providerData);

        userDataStore.storeUserData(tempUserData);
        preferencesHelper.setUserData(tempUserData);

        Navigator.pushNamed(context, Constants.ROUTE_HOME);
      } else {
        print("Authentication failed");
      }
    });
  }

  Widget googlButton(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Color(0xff4B8DEE)),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        // color: Colors.blue[900],
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 8, right: 0, bottom: 8, left: 8),
                child: Image.asset('assets/images/googl.png'),
              ),
              Expanded(
                child: Container(
                  child: FlatButton(
                      onPressed: () {
                        googleSignIn(context);
                        //
                        // Authentication().getCurrentUser();
                        // Navigator.of(context)
                        //     .pushNamed(Constants.ROUTE_HOME)
                        //     .then((results) {
                        //   print("this is results $results");
                        // });
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage()));
                        print("google button clicked");
                      },
                      child: Text(
                        "Google",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
              )
            ],
          ),
        ));
  }

  Widget phoneButton(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: Color(0xff6FAF5A)),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        // color: Colors.blue[900],
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 8, right: 0, bottom: 8, left: 8),
                child: Image.asset('assets/images/phone.png'),
              ),
              Expanded(
                child: Container(
                  child: FlatButton(
                      onPressed: () {
                        userDataStore.phoneVisibility = true;
                        userDataStore.codeVisibility = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneSignInSection()));
                      },
                      child: Text(
                        "Phone",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
              )
            ],
          ),
        ));
  }
}

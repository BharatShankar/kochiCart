import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kochicart/main.dart';
import 'package:kochicart/models/userData.dart';
import 'package:kochicart/stores/user/userDataStore.dart';
import 'package:kochicart/utils/sharedPreferencesHelper.dart';

import 'constants/Constants.dart';

class NavDrawer extends StatelessWidget {
  SharedPreferencesHelper prefs = SharedPreferencesHelper();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Observer(
              builder: (BuildContext context) {
                UserData userData = userDataStore?.userData;
                String profileImage = userData?.profileUrl ??
                    'https://www.woolha.com/media/2020/03/eevee.png';

                print("profileUrl: ${userData?.profileUrl ?? "None"}");
                String name = userData?.displayName ?? "N/A";
                print("profileUrl: ${userData?.profileUrl ?? "None"}");
                print("user provider id is ${userData.providerId}");
                var nameOrPhone = name;
                if (userData.providerId == "phone") {
                  nameOrPhone = userData.phoneNum;
                }
                return Column(children: <Widget>[
                  CircleAvatar(
                    minRadius: 40,
                    maxRadius: 50,
                    backgroundColor: Colors.red,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$nameOrPhone",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ]);
              },
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              Navigator.pop(context),
              Navigator.pop(context),
              auth.signOut(userDataStore.userData.providerId),

              //Navigator.pushReplacement(context, "/Login");
              // Navigator.of(context)
              //     .popUntil(ModalRoute.withName(Constants.ROUTE_LOGIN))
            },
          ),
        ],
      ),
    );
  }
}

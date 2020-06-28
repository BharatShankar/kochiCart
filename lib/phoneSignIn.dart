import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kochicart/main.dart';

import 'constants/Constants.dart';
import 'models/userData.dart';

class PhoneSignInSection extends StatefulWidget {
  // PhoneSignInSection(this._scaffold);

  // final ScaffoldState _scaffold;
  @override
  State<StatefulWidget> createState() => PhoneSignInSectionState();
}

class PhoneSignInSectionState extends State<PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Observer(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: const Text(
                  'Phone number verification',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
              Visibility(
                visible: userDataStore.phoneVisibility,
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                      labelText: 'Phone number (+x xxx-xxx-xxxx)'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Phone number (+x xxx-xxx-xxxx)';
                    }
                    return null;
                  },
                ),
              ),
              Visibility(
                visible: userDataStore.phoneVisibility,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () async {
                      auth.checkPhoneNumber(_phoneNumberController.text);
                    },
                    child: const Text('Verify phone number'),
                  ),
                ),
              ),
              Visibility(
                visible: userDataStore.codeVisibility,
                child: TextField(
                  controller: _smsController,
                  decoration:
                      const InputDecoration(labelText: 'Verification code'),
                ),
              ),
              Visibility(
                visible: userDataStore.codeVisibility,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () async {
                      //auth.signInWithPhoneNumber(_smsController.text);
                      phoneSignIn(_smsController.text);
                    },
                    child: const Text('Sign in with phone number'),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _message,
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void phoneSignIn(String smsTxt) {
    auth.signInWithPhoneNumber(smsTxt).then((user) {
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

        Navigator.popAndPushNamed(context, Constants.ROUTE_HOME);
      } else {
        print("Authentication failed");
      }
    });
  }
}

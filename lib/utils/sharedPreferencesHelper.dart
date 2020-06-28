import 'dart:convert';

import 'package:kochicart/models/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final String _loginCredentialsPrefs = "loginCredentials";
  final String userData = "userData";

  // void setLoginCredentials(data) async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String encodedData = json.encode(data);
  //   prefs.setString(_loginCredentialsPrefs, encodedData);
  // }

  // void saveDeviceToken(String deviceToken) async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(deviceToken, Constants.PREF_FCM_TOKEN);
  // }

  //  dynamic getDeviceToken() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.get(Constants.PREF_FCM_TOKEN);
  //   return token;
  // }

  // Future<LoginCredentials> getLoginCredentials() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var dec = json.decode(prefs.getString(_loginCredentialsPrefs));
  //   return LoginCredentials.fromJson(dec as Map<String, dynamic>);
  // }

  void setUserData(data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(data);
    prefs.setString(userData, encodedData);
  }

  Future<UserData> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = prefs.getString(userData);
    if (encodedData != null) {
      var dec = json.decode(encodedData);
      return UserData.fromJson(dec as Map<String, dynamic>);
    }
    return null;
  }
}

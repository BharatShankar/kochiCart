import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

abstract class BaseAuth {
  Future<FirebaseUser> googlesignIn(BuildContext context);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  // Future<void> signOut();
  Future<void> signOut(String providerId);
  Future<void> googleSignout();
  Future<void> facebookLoginout();

  Future<bool> isEmailVerified();
}

class Authentication implements BaseAuth {
  String _verificationId = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signIn(String email, String password) async {
    final FirebaseAuth _firebaseAuth1 = FirebaseAuth.instance;
    AuthResult result = await _firebaseAuth1.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    //if (user.isEmailVerified) {
    print('data = ${user.providerData}');
    print('email = ${user.email}');
    print('uid = ${user.uid}');
    print('displayName = ${user.displayName}');
    print('phoneNumber = ${user.phoneNumber}');
    print('photoUrl = ${user.photoUrl}');
    print('providerId = ${user.providerId}');
    print('toString = ${user.toString}');
    return user;
    //}

    // return null;
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    try {
      // await user.sendEmailVerification();
      return user;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      return null;
    }
  }

  Future<FirebaseUser> googlesignIn(BuildContext context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final AuthResult authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
      return user;
    }
    return null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      // if(user.providerData.length==2 && user.providerData[1].providerId == "facebook.com" || user.providerData[1].providerId == "google.com"){
      //   return user;
      // }
      // }else if(user.isEmailVerified){
      //   return user;
      // }
      print("===== = = = == ");
      print(user.email);
      print(user.displayName);
      return user;
    }
    return null;
  }

  Future<void> signOut(String providerId) async {
    await _firebaseAuth.signOut();
    if (providerId != null && providerId == "google") {
      googleSignout();
    }
  }

  Future<void> googleSignout() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'profile',
        'email',
      ],
    );
    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.signOut();
    } else {
      return;
    }
  }

  Future<FirebaseUser> signInWithPhoneNumber(String smsText) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: smsText,
    );
    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    return user;
  }

  // Future<void> facebookLoginout() async {
  //   await _firebaseAuth.signOut();
  //   await fbLogin.logOut();
  //   // return true;
  // }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> facebookLoginout() {
    // implement facebookLoginout
    return null;
  }

  void checkPhoneNumber(String phoneNum) async {
    var _message = '';

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth.signInWithCredential(phoneAuthCredential);

      _message = 'Received phone auth credential: $phoneAuthCredential';
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _message =
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      print("'Please check your phone for the verification code.'");

      print(verificationId);
      _verificationId = verificationId;
      userDataStore.phoneVisibility = false;
      userDataStore.codeVisibility = true;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}

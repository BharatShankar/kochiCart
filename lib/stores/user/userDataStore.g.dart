// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userDataStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserDataStore on _UserDataStore, Store {
  final _$userDataAtom = Atom(name: '_UserDataStore.userData');

  @override
  UserData get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(UserData value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

  final _$codeVisibilityAtom = Atom(name: '_UserDataStore.codeVisibility');

  @override
  bool get codeVisibility {
    _$codeVisibilityAtom.reportRead();
    return super.codeVisibility;
  }

  @override
  set codeVisibility(bool value) {
    _$codeVisibilityAtom.reportWrite(value, super.codeVisibility, () {
      super.codeVisibility = value;
    });
  }

  final _$phoneVisibilityAtom = Atom(name: '_UserDataStore.phoneVisibility');

  @override
  bool get phoneVisibility {
    _$phoneVisibilityAtom.reportRead();
    return super.phoneVisibility;
  }

  @override
  set phoneVisibility(bool value) {
    _$phoneVisibilityAtom.reportWrite(value, super.phoneVisibility, () {
      super.phoneVisibility = value;
    });
  }

  final _$_UserDataStoreActionController =
      ActionController(name: '_UserDataStore');

  @override
  dynamic storeUserData(UserData userData) {
    final _$actionInfo = _$_UserDataStoreActionController.startAction(
        name: '_UserDataStore.storeUserData');
    try {
      return super.storeUserData(userData);
    } finally {
      _$_UserDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userData: ${userData},
codeVisibility: ${codeVisibility},
phoneVisibility: ${phoneVisibility}
    ''';
  }
}

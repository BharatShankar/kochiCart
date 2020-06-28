import 'package:kochicart/models/userData.dart';
import 'package:mobx/mobx.dart';

part 'userDataStore.g.dart';

class UserDataStore = _UserDataStore with _$UserDataStore;

abstract class _UserDataStore with Store {
  @observable
  UserData userData = new UserData();

  @observable
  bool codeVisibility = false;
  @observable
  bool phoneVisibility = true;

  @action
  storeUserData(UserData userData) {
    print("Data $userData");
    this.userData = userData;
  }
}

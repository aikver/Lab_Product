import 'package:flutter/material.dart';
import 'package:testlab/models/user_models.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  String? _accessToken;
  String? _refreshToken;

  User get user => _user!;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  get userData => null;

  void onLogin(UserModel userModel ) async {
    _user = userModel.user;
    _accessToken = userModel.accessToken;
    _refreshToken = userModel.refreshToken;
    notifyListeners();
  } 

  void onLogout() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void updateAccessToken(String newAccess) {
    _accessToken = newAccess;
    notifyListeners();
  }

  void addUser(String text, String text2) {}

  void updateUser(int index, String text, String text2) {}

  deleteUser(int index) {}
}
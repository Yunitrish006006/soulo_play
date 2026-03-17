import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  bool _loggedIn = false;
  String? _username;

  bool get isLoggedIn => _loggedIn;
  String? get username => _username;

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // demo fake auth: accept any username with password 'password'
    if (password == 'password') {
      _loggedIn = true;
      _username = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _loggedIn = false;
    _username = null;
    notifyListeners();
  }
}

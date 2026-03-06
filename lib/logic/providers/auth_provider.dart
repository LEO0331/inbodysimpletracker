import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;

  AuthProvider() {
    _authService.userChanges.listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> signup(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}

import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isAdmin = false;
  bool _isLoading = true; // 新增：追蹤初始化狀態

  // Getter
  User? get user => _user;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // 監聽 Auth 狀態改變
    _authService.userChanges.listen((u) async {
      _user = u;
      
      if (u != null) {
        // 如果使用者登入，去檢查是否為 Admin
        _isAdmin = await _authService.isAdmin();
        developer.log("User logged in: ${u.email}, isAdmin: $_isAdmin", name: "auth.provider");
      } else {
        // 登出時重設狀態
        _isAdmin = false;
        developer.log("User logged out", name: "auth.provider");
      }
      
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _authService.signIn(email, password);
      // 注意：AuthService 內部的 userChanges 會觸發上面的 listen，所以這裡不用手動 notify
    } catch (e) {
      developer.log("Login failed", name: "auth.provider", error: e);
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await _authService.signUp(email, password);
    } catch (e) {
      developer.log("Signup failed", name: "auth.provider", error: e);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}

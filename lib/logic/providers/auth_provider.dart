import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isAdmin = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get user => _user;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider({AuthService? authService}) 
    : _authService = authService ?? AuthService() {
    final currentUser = _authService.currentUser;
    _user = currentUser;
    _isAuthenticated = currentUser != null;
    // Monitor auth state changes
    _authService.userChanges.listen((u) async {
      _user = u;
      _isAuthenticated = u != null;

      if (u != null) {
        // User logged in - check if admin
        try {
          _isAdmin = await _authService.isAdmin();
          developer.log(
            "User logged in: ${u.email}, isAdmin: $_isAdmin",
            name: "auth.provider",
          );
          _errorMessage = null; // Clear error on successful login
        } catch (e) {
          developer.log(
            "Error checking admin status",
            name: "auth.provider",
            error: e,
          );
          _errorMessage = "Error loading user data";
        }
      } else {
        // User logged out - reset state
        _isAdmin = false;
        _errorMessage = null;
        developer.log("User logged out", name: "auth.provider");
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email and password cannot be empty");
      }

      await _authService.signIn(email, password);
      // Note: userChanges stream will handle state updates
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);
      developer.log(
        "Login failed: ${e.code}",
        name: "auth.provider",
        error: e,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (_errorMessage == null || _errorMessage!.isEmpty) {
        _errorMessage = "Login failed. Please try again.";
      }
      developer.log(
        "Login error",
        name: "auth.provider",
        error: e,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email and password cannot be empty");
      }

      if (!email.contains('@') || !email.contains('.')) {
        throw Exception("Please enter a valid email address");
      }

      if (password.length < 6) {
        throw Exception("Password must be at least 6 characters");
      }

      await _authService.signUp(email, password);
      // Note: userChanges stream will handle state updates
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);
      developer.log(
        "Signup failed: ${e.code}",
        name: "auth.provider",
        error: e,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (_errorMessage == null || _errorMessage!.isEmpty) {
        _errorMessage = "Signup failed. Please try again.";
      }
      developer.log(
        "Signup error",
        name: "auth.provider",
        error: e,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.signOut();
      // userChanges stream will handle state updates
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (_errorMessage == null || _errorMessage!.isEmpty) {
        _errorMessage = "Logout failed";
      }
      developer.log(
        "Logout error",
        name: "auth.provider",
        error: e,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Convert Firebase error codes to user-friendly messages
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
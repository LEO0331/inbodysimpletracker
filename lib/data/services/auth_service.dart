import 'dart:developer' as developer; // 引入 developer.log
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 註冊邏輯
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      final String uid = credential.user!.uid;

      await _db.collection("users").doc(uid).set({
        "email": email,
        "role": "user", 
        "createdAt": FieldValue.serverTimestamp(),
      });

      developer.log("User signed up successfully: $email", name: "auth.service");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      developer.log("Auth Error: ${e.message}", name: "auth.service", error: e);
      rethrow;
    } catch (e) {
      developer.log("Firestore Error: $e", name: "auth.service", error: e);
      rethrow;
    }
  }

  // 登入邏輯
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      developer.log("User signed in: $email", name: "auth.service");
      return credential.user;
    } catch (e) {
      developer.log("SignIn Error: $e", name: "auth.service", error: e);
      rethrow;
    }
  }

  // --- 新增：檢查當前登入者是否為 Admin ---
  Future<bool> isAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _db.collection("users").doc(user.uid).get();
      final String? role = doc.data()?['role'] as String?;
      
      return role == "admin";
    } catch (e) {
      developer.log("isAdmin Check Error: $e", name: "auth.service", error: e);
      return false;
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  Stream<User?> get userChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;
}

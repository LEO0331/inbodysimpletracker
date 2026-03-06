import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../logic/providers/auth_provider.dart';
import '../presentation/admin/admin_page.dart';
import '../presentation/auth/login_page.dart';
import '../presentation/dashboard/dashboard_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole(String uid) async {
    final doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return doc.data()?["role"];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.user == null) {
      // Not logged in → show login page
      return const LoginPage();
    }

    // Logged in → check role
    return FutureBuilder<String?>(
      future: _getUserRole(auth.user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data;
        if (role == "admin") {
          return const AdminPage();
        } else {
          return const DashboardPage();
        }
      },
    );
  }
}

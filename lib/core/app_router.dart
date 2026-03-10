import 'package:flutter/material.dart';
import '../presentation/auth/login_page.dart';
import '../presentation/auth/signup_page.dart';
import '../presentation/dashboard/dashboard_page.dart';
import '../presentation/upload/upload_page.dart';
import '../presentation/admin/admin_page.dart';
import '../presentation/auth/home_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/upload':
        return MaterialPageRoute(builder: (_) => const UploadPage());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
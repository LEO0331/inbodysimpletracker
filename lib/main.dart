import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'logic/providers/auth_provider.dart';
import 'logic/providers/report_provider.dart';

// 匯入所有需要的頁面
import 'presentation/admin/admin_page.dart';
import 'presentation/auth/home_page.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/signup_page.dart';
import 'presentation/dashboard/dashboard_page.dart';
import 'presentation/upload/upload_page.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MaterialApp(
        title: 'InBody Tracker',
        debugShowCheckedModeBanner: false, // 隱藏右上角 Debug 標籤
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(), 
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/upload': (context) => const UploadPage(),
          '/admin': (context) => const AdminPage(),
        },
      ),
    );
  }
}

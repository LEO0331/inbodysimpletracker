import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // ✅ 新增
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'logic/providers/auth_provider.dart';
import 'logic/providers/report_provider.dart';
import 'logic/providers/mqtt_provider.dart';

// 匯入所有需要的頁面
import 'presentation/admin/admin_page.dart';
import 'presentation/auth/home_page.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/auth/signup_page.dart';
import 'presentation/dashboard/dashboard_page.dart';
import 'presentation/upload/upload_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ 核心修復：設定 Firebase Auth 持久化
  if (kIsWeb) {
    try {
      // 設定為 SESSION：瀏覽器分頁關閉後自動登出
      await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    } catch (e) {
      debugPrint("Firebase Persistence Error: $e");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 注意：AuthProvider 內部建構子現在會自動監聽 Auth 狀態
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MaterialApp(
        title: 'InBody Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // ✅ 建議：改用命名路由初始化，保持一致性
        initialRoute: '/', 
        routes: {
          '/': (context) => const HomePage(),
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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'logic/providers/auth_provider.dart';
import 'logic/providers/report_provider.dart';

// 匯入所有需要的頁面
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
      ],
      child: MaterialApp(
        title: 'InBody Tracker',
        debugShowCheckedModeBanner: false, // 隱藏右上角 Debug 標籤
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // ✅ 方案：保留 home 作為進入點，並在 routes 中定義跳轉路徑
        home: const HomePage(), 
        routes: {
          // ⚠️ 注意：不要在這裡重複定義 '/'，否則會跟 home 衝突
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/upload': (context) => const UploadPage(),
        },
      ),
    );
  }
}

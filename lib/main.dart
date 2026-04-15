import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'logic/providers/auth_provider.dart';
import 'logic/providers/report_provider.dart';
import 'presentation/auth/home_page.dart';
import 'presentation/auth/login_page.dart' deferred as login_page;
import 'presentation/auth/signup_page.dart' deferred as signup_page;
import 'presentation/admin/admin_page.dart' deferred as admin_page;
import 'presentation/dashboard/dashboard_page.dart' deferred as dashboard_page;
import 'logic/providers/mqtt_provider.dart' deferred as mqtt_provider;
import 'presentation/upload/upload_page.dart' deferred as upload_page;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BootstrapApp());
}

class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  late final Future<void> _bootstrapFuture = _bootstrap();

  Future<void> _bootstrap() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kIsWeb) {
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
      } catch (e) {
        debugPrint('Firebase Persistence Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        return MaterialApp(
          title: 'InBody Tracker',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
          home: const _StartupScreen(),
        );
      },
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 68,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'InBody Tracker',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Preparing your dashboard...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 240,
                  child: LinearProgressIndicator(minHeight: 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ThemeData _buildTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );
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
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomePage(),
        );
      case '/login':
        return _buildDeferredRoute(
          settings: settings,
          loadLibrary: login_page.loadLibrary,
          builder: () => login_page.LoginPage(),
          label: 'Loading login...',
        );
      case '/signup':
        return _buildDeferredRoute(
          settings: settings,
          loadLibrary: signup_page.loadLibrary,
          builder: () => signup_page.SignupPage(),
          label: 'Loading sign up...',
        );
      case '/dashboard':
        return _buildDeferredRoute(
          settings: settings,
          loadLibrary: () async {
            await Future.wait([
              dashboard_page.loadLibrary(),
              mqtt_provider.loadLibrary(),
            ]);
          },
          builder: () => ChangeNotifierProvider(
            create: (_) => mqtt_provider.MqttProvider(),
            child: dashboard_page.DashboardPage(),
          ),
          label: 'Loading dashboard...',
        );
      case '/upload':
        return _buildDeferredRoute(
          settings: settings,
          loadLibrary: () async {
            await Future.wait([
              upload_page.loadLibrary(),
              mqtt_provider.loadLibrary(),
            ]);
          },
          builder: () => ChangeNotifierProvider(
            create: (_) => mqtt_provider.MqttProvider(),
            child: upload_page.UploadPage(),
          ),
          label: 'Loading scanner...',
        );
      case '/admin':
        return _buildDeferredRoute(
          settings: settings,
          loadLibrary: admin_page.loadLibrary,
          builder: () => admin_page.AdminPage(),
          label: 'Loading admin tools...',
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomePage(),
        );
    }
  }
}

MaterialPageRoute<void> _buildDeferredRoute({
  required RouteSettings settings,
  required Future<void> Function() loadLibrary,
  required Widget Function() builder,
  required String label,
}) {
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => _DeferredRouteScreen(
      loadLibrary: loadLibrary,
      builder: builder,
      label: label,
    ),
  );
}

class _DeferredRouteScreen extends StatefulWidget {
  const _DeferredRouteScreen({
    required this.loadLibrary,
    required this.builder,
    required this.label,
  });

  final Future<void> Function() loadLibrary;
  final Widget Function() builder;
  final String label;

  @override
  State<_DeferredRouteScreen> createState() => _DeferredRouteScreenState();
}

class _DeferredRouteScreenState extends State<_DeferredRouteScreen> {
  late final Future<void> _loadFuture = widget.loadLibrary();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return widget.builder();
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2.6),
                ),
                const SizedBox(height: 12),
                Text(widget.label),
              ],
            ),
          ),
        );
      },
    );
  }
}

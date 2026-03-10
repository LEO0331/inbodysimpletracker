import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:inbodysimpletracker/core/app_router.dart';
import 'package:inbodysimpletracker/presentation/auth/home_page.dart';
import 'package:inbodysimpletracker/presentation/auth/login_page.dart';
import 'package:inbodysimpletracker/presentation/auth/signup_page.dart';
import 'package:inbodysimpletracker/presentation/upload/upload_page.dart';
import 'package:inbodysimpletracker/presentation/dashboard/dashboard_page.dart';
import 'package:inbodysimpletracker/presentation/admin/admin_page.dart';

// 1. 使用 mocktail 建立 MockBuildContext
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockBuildContext mockContext;

  setUp(() {
    mockContext = MockBuildContext();
  });

  group('AppRouter 路由導航測試 (Unit Test)', () {
    
    // 輔助函式：執行 Route 的 builder 並獲取產生的 Widget
    Widget getBuiltWidget(Route<dynamic>? route) {
      expect(route, isA<MaterialPageRoute>());
      return (route as MaterialPageRoute).builder(mockContext);
    }

    test('根路徑 "/" 應返回 HomePage', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/'));
      expect(getBuiltWidget(route), isA<HomePage>());
    });

    test('"/login" 應返回 LoginPage', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/login'));
      expect(getBuiltWidget(route), isA<LoginPage>());
    });

    test('"/signup" 應返回 SignupPage', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/signup'));
      expect(getBuiltWidget(route), isA<SignupPage>());
    });

    test('"/upload" 應返回 UploadPage', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/upload'));
      expect(getBuiltWidget(route), isA<UploadPage>());
    });

    test('"/dashboard" 應返回 DashboardPage', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/dashboard'));
      expect(getBuiltWidget(route), isA<DashboardPage>());
    });

    test('"/admin" 應返回 AdminPage', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/admin'));
      expect(getBuiltWidget(route), isA<AdminPage>());
    });

    test('未定義路徑應返回 Error Scaffold', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/unknown'));
      final widget = getBuiltWidget(route);
      
      expect(widget, isA<Scaffold>());
      // 驗證錯誤文字是否存在
      final scaffold = widget as Scaffold;
      expect(scaffold.appBar, isNotNull);
      expect((scaffold.body as Center).child, isA<Text>());
      expect(((scaffold.body as Center).child as Text).data, 'Route not found');
    });
  });
}

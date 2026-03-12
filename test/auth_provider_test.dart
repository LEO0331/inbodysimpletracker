import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:inbodysimpletracker/logic/providers/auth_provider.dart';
import 'package:inbodysimpletracker/data/services/auth_service.dart';

// 建立 Mock 類別
class MockAuthService extends Mock implements AuthService {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;
  late AuthProvider authProvider;
  late StreamController<User?> userStreamController;
  late MockUser mockUser;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    userStreamController = StreamController<User?>();

    // 模擬 User 屬性
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.uid).thenReturn('uid_123');

    // 模擬 AuthService 的 Stream 與 currentUser
    when(() => mockAuthService.userChanges).thenAnswer((_) => userStreamController.stream);
    when(() => mockAuthService.currentUser).thenReturn(null);

    // 注入 Mock 到 Provider
    authProvider = AuthProvider(authService: mockAuthService);
  });

  tearDown(() {
    userStreamController.close();
  });

  group('AuthProvider 測試', () {
    test('初始狀態檢查 - 應為載入中且未驗證', () {
      expect(authProvider.isLoading, isTrue);
      expect(authProvider.isAuthenticated, isFalse);
    });

    test('登入失敗 - 應捕捉 FirebaseAuthException 並轉換錯誤訊息', () async {
      // 模擬登入拋出錯誤
      when(() => mockAuthService.signIn('bad@email.com', 'wrong'))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      await authProvider.login('bad@email.com', 'wrong');

      expect(authProvider.errorMessage, equals('Incorrect password. Please try again.'));
      expect(authProvider.isLoading, isFalse);
    });

    test('登入成功 - 狀態應隨 Stream 自動更新並檢查 Admin 權限', () async {
      // 1. 模擬 Admin 檢查回傳 true
      when(() => mockAuthService.isAdmin()).thenAnswer((_) async => true);
      when(() => mockAuthService.signIn(any(), any())).thenAnswer((_) async => null);

      // 2. 執行登入行為
      await authProvider.login('admin@test.com', 'password123');

      // 3. 模擬 Firebase 透過 Stream 發送 User 物件
      userStreamController.add(mockUser);

      // 等待 Microtasks 執行（讓 listen 裡的 async 跑完）
      await Future.delayed(Duration.zero);

      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.user?.email, equals('test@example.com'));
      expect(authProvider.isAdmin, isTrue);
      expect(authProvider.isLoading, isFalse);
    });

    test('註冊驗證 - 信箱格式不正確應直接拋出異常', () async {
      await authProvider.signup('invalid-email', '123456');

      expect(authProvider.errorMessage, equals('Signup failed. Please try again.'));
      expect(authProvider.isLoading, isFalse);
      // 驗證並未真正調用後端註冊
      verifyNever(() => mockAuthService.signUp(any(), any()));
    });

    test('登出 - 狀態應重置', () async {
      when(() => mockAuthService.signOut()).thenAnswer((_) async {});

      await authProvider.logout();

      // 模擬 Stream 發送 null
      userStreamController.add(null);
      await Future.delayed(Duration.zero);

      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.isAdmin, isFalse);
      expect(authProvider.user, isNull);
    });

    test('clearError 應能清除錯誤訊息', () async {
      // 先製造一個錯誤
      when(() => mockAuthService.signIn(any(), any()))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));
      await authProvider.login('none@test.com', '123');

      expect(authProvider.errorMessage, isNotNull);

      // 執行清除
      authProvider.clearError();
      expect(authProvider.errorMessage, isNull);
    });
  });
}

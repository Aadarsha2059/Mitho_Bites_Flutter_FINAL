import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_login_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';

class DummyUserLoginUsecase implements UserLoginUsecase {
  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return Right('dummy_token');
  }
}

class DummyLoginViewModel extends LoginViewModel {
  DummyLoginViewModel() : super(DummyUserLoginUsecase());
}

void main() {
  setUp(() {
    final sl = GetIt.instance;
    if (!sl.isRegistered<LoginViewModel>()) {
      sl.registerFactory<LoginViewModel>(() => DummyLoginViewModel());
    }
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<LoginViewModel>()) {
      sl.unregister<LoginViewModel>();
    }
  });

  testWidgets('LoginView has username, password fields and login button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginView(),
      ),
    );
    expect(find.byKey(const ValueKey('username')), findsOneWidget);
    expect(find.byKey(const ValueKey('password')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
} 
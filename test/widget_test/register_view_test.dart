import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/user/presentation/view/register_view.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_register_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';

class DummyUserRegisterUsecase implements UserRegisterUsecase {
  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    return Right(null);
  }
}

class DummyRegisterViewModel extends RegisterViewModel {
  DummyRegisterViewModel() : super(DummyUserRegisterUsecase());
}

void main() {
  setUp(() {
    final sl = GetIt.instance;
    if (!sl.isRegistered<RegisterViewModel>()) {
      sl.registerFactory<RegisterViewModel>(() => DummyRegisterViewModel());
    }
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<RegisterViewModel>()) {
      sl.unregister<RegisterViewModel>();
    }
  });

  testWidgets('RegisterView has full name, username, email, and sign up button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterView(),
      ),
    );
    expect(find.widgetWithText(TextFormField, 'Full Name *'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Username *'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email *'), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets);
  });
} 
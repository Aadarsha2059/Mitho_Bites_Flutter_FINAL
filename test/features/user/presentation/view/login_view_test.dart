import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fooddelivery_b/features/user/presentation/view/login_view.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_event.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_state.dart';
import 'package:fooddelivery_b/features/user/presentation/view_model/login_view_model/login_view_model.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    registerFallbackValue(LoginWithUsernameAndPasswordEvent(
      context: FakeBuildContext(),
      username: '',
      password: '',
    ));
  });

  Widget buildTestable({required MockLoginBloc bloc}) {
    return MaterialApp(
      home: LoginView(injectedViewModel: bloc),
    );
  }

  testWidgets('renders username and password fields and login button', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState.initial());
    await tester.pumpWidget(buildTestable(bloc: mockLoginBloc));
    expect(find.byKey(const ValueKey('username')), findsOneWidget);
    expect(find.byKey(const ValueKey('password')), findsOneWidget);
    expect(find.text('Login Page'), findsOneWidget);
    expect(find.text('Sign in!'), findsOneWidget);
  });

  testWidgets('shows loading overlay when isLoading is true', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState(isLoading: true, isSuccess: false));
    await tester.pumpWidget(buildTestable(bloc: mockLoginBloc));
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('dispatches LoginWithUsernameAndPasswordEvent when login button is tapped', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState.initial());
    await tester.pumpWidget(buildTestable(bloc: mockLoginBloc));
    await tester.enterText(find.byKey(const ValueKey('username')), 'testuser');
    await tester.enterText(find.byKey(const ValueKey('password')), 'testpass');
    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pump();
    // Use captureAny to get the event
    final captured = verify(() => mockLoginBloc.add(captureAny())).captured;
    expect(captured.length, 1);
    expect(captured.first, isA<LoginWithUsernameAndPasswordEvent>());
    final event = captured.first as LoginWithUsernameAndPasswordEvent;
    expect(event.username, 'testuser');
    expect(event.password, 'testpass');
  });

  testWidgets('shows validation error if fields are empty', (tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState.initial());
    await tester.pumpWidget(buildTestable(bloc: mockLoginBloc));
    await tester.enterText(find.byKey(const ValueKey('username')), '');
    await tester.enterText(find.byKey(const ValueKey('password')), '');
    final loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pump();
    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  testWidgets('navigates to HomeView when isSuccess is true', (tester) async {
    whenListen(
      mockLoginBloc,
      Stream.fromIterable([
        const LoginState.initial(),
        const LoginState(isLoading: false, isSuccess: true),
      ]),
      initialState: const LoginState.initial(),
    );
    await tester.pumpWidget(buildTestable(bloc: mockLoginBloc));
    await tester.pumpAndSettle();
    expect(find.byType(LoginView), findsNothing);
  });
}
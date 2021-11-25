import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErroController;
  late StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String?>();
    passwordErroController = StreamController<String?>();
    isFormValidController = StreamController<bool>();

    when(() => presenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErroController.stream);
    when(() => presenter.isFormValid)
        .thenAnswer((_) => isFormValidController.stream);

    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErroController.close();
    isFormValidController.close();
  });

  testWidgets('Should load with correct initial values',
      (WidgetTester tester) async {
    await loadPage(tester);

    //Encontrar todos os filhos do tipo text do campo de email
    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    // Se encontrar mais de um filho é porque o campo de email contém um erro
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'Quando o textFormField contem apenas um filho, ele não contem erros, pois um dos filhos é o label text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
    );

    final button = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );

    expect(button.onPressed, equals(null));
  });

  testWidgets('Should call Validate with email', (WidgetTester tester) async {
    await loadPage(tester);
    final email = Faker().internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));
  });

  testWidgets('Should call validade with password',
      (WidgetTester tester) async {
    await loadPage(tester);
    final password = Faker().internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add('error');
    await tester.pump();
    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Should present valid email', (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add(null);
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present valid email', (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add('');
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);
    passwordErroController.add('error');
    await tester.pump();

    expect(
      find.text('error'),
      findsOneWidget,
    );
  });

  testWidgets('Should present valid password ', (WidgetTester tester) async {
    await loadPage(tester);
    passwordErroController.add(null);
    await tester.pump();

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should present valid password ', (WidgetTester tester) async {
    await loadPage(tester);
    passwordErroController.add('');
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should disabled button if invalid form',
      (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(false);
    await tester.pump();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => presenter.auth()).called(1);
  });
}

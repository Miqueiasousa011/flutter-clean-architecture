import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();

    when(() => presenter.emailErrorStream).thenAnswer(
      (_) => emailErrorController.stream,
    );

    final loginPage = MaterialApp(home: LoginPage(presenter: presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
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
}

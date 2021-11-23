import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/pages/pages.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    const loginPage = MaterialApp(home: LoginPage());
    //manda renderizar a pagina de login
    await tester.pumpWidget(loginPage);
  }

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
}

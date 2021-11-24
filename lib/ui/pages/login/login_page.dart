import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const Headline1(text: 'login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    onChanged: presenter?.validateEmail,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.lock,
                            color: Theme.of(context).primaryColorLight),
                      ),
                      obscureText: true,
                      onChanged: presenter?.validatePassword,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Entrar'.toUpperCase()),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                    label: Text('Criar conta'.toUpperCase()),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}

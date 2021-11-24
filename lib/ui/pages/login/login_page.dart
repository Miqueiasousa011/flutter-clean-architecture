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
                  StreamBuilder<String?>(
                      stream: presenter?.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                            errorText: snapshot.data?.isEmpty == true
                                ? null
                                : snapshot.data,
                            labelText: 'Email',
                            icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          onChanged: presenter?.validateEmail,
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                    child: StreamBuilder<String?>(
                        stream: presenter?.passwordErrorStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              icon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                            ),
                            obscureText: true,
                            onChanged: presenter?.validatePassword,
                          );
                        }),
                  ),
                  StreamBuilder<bool>(
                      stream: presenter?.isFormValid,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed: snapshot.data == true ? () {} : null,
                          child: Text('Entrar'.toUpperCase()),
                        );
                      }),
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

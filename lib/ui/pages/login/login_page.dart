import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({Key? key, required this.presenter}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();

    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter?.isLoadingController.listen((bool isLoading) {
          if (isLoading) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const SimpleDialog(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('loading...', textAlign: TextAlign.center),
                ],
              ),
            );
          } else {
            if (Navigator.canPop(context)) Navigator.of(context).pop();
          }
        });

        widget.presenter?.mainErrorController.listen((error) {
          if (error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error)));
          }
        });

        return SingleChildScrollView(
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
                        stream: widget.presenter?.emailErrorStream,
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
                            onChanged: widget.presenter?.validateEmail,
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                      child: StreamBuilder<String?>(
                          stream: widget.presenter?.passwordErrorStream,
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
                              onChanged: widget.presenter?.validatePassword,
                            );
                          }),
                    ),
                    StreamBuilder<bool>(
                        stream: widget.presenter?.isFormValid,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            onPressed: snapshot.data == true
                                ? widget.presenter?.auth
                                : null,
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
        );
      }),
    );
  }
}

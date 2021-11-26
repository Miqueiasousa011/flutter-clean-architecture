import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import './components/components.dart';

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
        widget.presenter?.isLoadingController.listen((bool isLoading) =>
            isLoading ? showLoading(context) : hideLoading(context));

        widget.presenter?.mainErrorController.listen((error) {
          if (error != null) showErrorMessage(context, error);
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const Headline1(text: 'login'),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Provider(
                  create: (_) => widget.presenter!,
                  child: Form(
                      child: Column(
                    children: [
                      const EmailInput(),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 32),
                        child: PasswordInput(),
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
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Image.asset('lib/ui/assets/logo.png'),
            ),
            Text('login'.toUpperCase()),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    icon: Icon(Icons.lock),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Entrar'.toUpperCase()),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                  label: Text('Criar conta'.toUpperCase()),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

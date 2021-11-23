import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    final ThemeData theme = ThemeData();

    return MaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        //accetColor
        colorScheme: theme.colorScheme.copyWith(
          primary: primaryColorDark,
        ),
        backgroundColor: Colors.white,
        textTheme: theme.textTheme.copyWith(
          headline1: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: primaryColorDark,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: primaryColorDark,
          selectionColor: primaryColorLight,
          selectionHandleColor: primaryColorDark,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: primaryColorDark),
          hoverColor: primaryColorDark,
          focusColor: primaryColorDark,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorDark),
          ),
          alignLabelWithHint: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
            overlayColor: MaterialStateProperty.all<Color>(primaryColorLight),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
          side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )),
        )),
      ),
      home: const LoginPage(),
    );
  }
}

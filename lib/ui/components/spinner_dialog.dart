import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
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
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) Navigator.of(context).pop();
}

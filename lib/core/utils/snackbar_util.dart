import 'package:flutter/material.dart';

void showError(BuildContext context, dynamic error) {
  final message = error
      .toString()
      .replaceAll('Exception: ', '')
      .replaceAll('Erro: ', '');

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
}

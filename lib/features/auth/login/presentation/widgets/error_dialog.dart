import 'package:flutter/material.dart';

void showErrorDialog(
  BuildContext context,
  String message,
) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget{

  final String tittle;
  final String error;
  final String okText;

  const ErrorDialog({
    super.key,
    required this.tittle,
    required this.error,
    required this.okText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(
          tittle,
          style: textTheme.headlineLarge,
        ),
      content : Text(
          error,
          style: textTheme.bodyLarge,
        ),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text(
            okText,
            style: textTheme.bodyLarge!.copyWith(color: colorScheme.primary),
          )
        ),
      ],
    );
  }
}
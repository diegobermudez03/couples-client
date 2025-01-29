import 'package:couples_client_app/shared/func_helpers.dart';
import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget{

  final String text;
  final void Function() handler;

  const GoogleAuthButton({
    super.key,
    required this.text,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: handler, 
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(3),

        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surfaceBright)
      ),
      child: Row(
        children: [
          const Spacer(),
           Image.asset(
            height: 30,
            getAsset('images/icons/google.png')

          ),
          const Spacer(flex: 2,),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),
          const Spacer(flex: 7,),
        ]
      ),
    );
  }
}
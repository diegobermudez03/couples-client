import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget{

  final String orText;

  const OrDivider({
    super.key,
    required this.orText
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 3,
          ),
        ),
        Text('   $orText   ', style: Theme.of(context).textTheme.bodyLarge,),
        const Expanded(
          child: Divider(
            thickness: 3,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatelessWidget{

  final String lottieURL;
  final String text;
  final String tittle;
  final bool righOrientation;

  const IntroPage({
    super.key,
    required this.lottieURL,
    required this.tittle,
    required this.text,
    this.righOrientation = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final aspect = MediaQuery.sizeOf(context).width / (MediaQuery.sizeOf(context).height/2.2);
    return Column(
      children: [
        const Spacer(flex: 2,),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            tittle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        AspectRatio(
          aspectRatio: aspect,
          child: Lottie.asset(
            lottieURL,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(flex: 1,),
        Text(
          text,
          textAlign: righOrientation ? TextAlign.right : TextAlign.left,
          style: Theme.of(context).textTheme.bodyMedium
        ),
        const Spacer(flex: 8,),
      ],
    );
  }
}
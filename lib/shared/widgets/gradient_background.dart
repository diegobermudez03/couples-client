import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget{

  final Color startColor, endColor;
  final Widget child;
  final bool horizontal;

  const GradientBackground({
    super.key,
    required this.startColor,
    required this.endColor,
    required this.child,
    this.horizontal = true,
  });
  @override
  Widget build(BuildContext context) {
    final begin = horizontal ? Alignment.centerLeft : Alignment.topCenter;
    final end = horizontal ? Alignment.centerRight : Alignment.bottomCenter;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}
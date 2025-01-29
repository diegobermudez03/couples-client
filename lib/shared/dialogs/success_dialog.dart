import 'package:couples_client_app/shared/func_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatefulWidget{
  final void Function()? callback;

  const SuccessDialog({
    super.key,
    this.callback,
  });
  
  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    );
    _controller.forward().whenCompleteOrCancel((){
      Navigator.of(context).pop();
      if(widget.callback != null){
        widget.callback!(); 
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Lottie.asset(
        controller: _controller,
        getAsset('animations/general/success.json'))
      ,
    );
  }
}
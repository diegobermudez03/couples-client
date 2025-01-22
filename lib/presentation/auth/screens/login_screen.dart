 import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("login")),
    );
  }
}

/*Widget _getLoginButton(String asset){
    return ElevatedButton(
      onPressed: (){}, 
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
        elevation: const WidgetStatePropertyAll(3)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Image.asset(
          getAsset(asset),
          height: 50,
        ),
      )
    );
  }*/
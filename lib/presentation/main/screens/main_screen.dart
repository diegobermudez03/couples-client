import 'package:couples_client_app/core/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: ()=>context.push(routeQuizzesHomepage), 
            child: const Text("Go to quizzes")
          )
        ],
      ),
    );
  }
}
import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/loading/bloc/loading_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';


class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoadingBloc, LoadingState>(
        listener: (context, state) {
          switch(state){
            case GoToLoginPageState _: context.go(routeLoginPage);break;
            case GoToUserPageState _:context.go(routeLogUserPage); break;
            case GoToConnectCouplePageState _: context.go(routeConnectCouplePage);break;
            case GoToMainPageState _ : context.go(routeMainPage); break;
          }
        },
        child: Center(
          child: Lottie.asset(
            'assets/animations/general/loading_placeholder.json',
            fit: BoxFit.fitHeight,
            width: 400,
            height: 400,
            delegates: LottieDelegates(
              text: (initialText) => '**$initialText**',
              values: [
                ValueDelegate.color(
                  const ['Rectangle_1', '**'],
                  value: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

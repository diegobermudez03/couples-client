import 'package:couples_client_app/presentation/auth/screens/connect_couple_screen.dart';
import 'package:couples_client_app/presentation/auth/screens/create_user_screen.dart';
import 'package:couples_client_app/presentation/auth/screens/login_screen.dart';
import 'package:couples_client_app/presentation/auth/screens/welcome_screen.dart';
import 'package:couples_client_app/presentation/loading/bloc/loading_bloc.dart';
import 'package:couples_client_app/presentation/loading/screens/loading_screen.dart';
import 'package:couples_client_app/presentation/main/screens/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

const String routeDefault = "/";
const String routeLoginPage = "/auth/login";
const String routeRegisterPage = "/auth/register";
const String routeWelcomePage = "/welcome";
const String routeLogUserPage = "/auth/user";
const String routeConnectCouplePage = "/auth/couple";
const String routeMainPage = "/main";

final router = GoRouter(routes: [
  GoRoute(
    path: routeDefault,
    builder: (_, __) => BlocProvider(
      create: (context) => GetIt.instance.get<LoadingBloc>(),
      child: LoadingScreen(),
    ),
    pageBuilder: GoTransitions.fadeUpwards,
  ),
   GoRoute(
    path: routeLoginPage,
    builder: (_, __) =>  LoginScreen(),
    pageBuilder: GoTransitions.openUpwards,
  ),
  GoRoute(
    path: routeWelcomePage,
    builder: (_, __) =>  WelcomeScreen(),
    pageBuilder: GoTransitions.fadeUpwards,
  ),
  GoRoute(
    path: routeLogUserPage,
    builder: (_, __) =>  CreateUserScreen(),
    pageBuilder: GoTransitions.openUpwards,
  ),
  GoRoute(
    path: routeConnectCouplePage,
    builder: (_, __) =>  ConnectCoupleScreen(),
    pageBuilder: GoTransitions.fadeUpwards,
  ),
  GoRoute(
    path: routeMainPage,
    builder: (_, __) =>  MainScreen(),
    pageBuilder: GoTransitions.fadeUpwards,
  ),

]);

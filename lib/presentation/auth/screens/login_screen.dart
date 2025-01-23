import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/bloc/login_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/auth_field.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final i10n = AppLocalizations.of(context)!;
    final bloc = BlocProvider.of<LoginBloc>(context);
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.sizeOf(context).height/20,
                color: colorScheme.onPrimary,
              ),
            ),
            SafeArea(
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if(state is LoginSuccessState){
                    switch(state.message){
                      case LoginNavigateMessage.goToUserCreation: context.go(routeLogUserPage);break;
                      case LoginNavigateMessage.goToCoupleConnection: context.go(routeConnectCouplePage);break;
                      case LoginNavigateMessage.goToMainPage: context.go(routeMainPage);break;
                    }
                  }
                  if(state is LoginFailedState){
                    final String message = switch(state.message){
                      LoginErrorMessage.emptyFields =>  i10n.youMustFillAllFields,
                      LoginErrorMessage.nonExistingEmail =>  i10n.youMustWriteAValidEmail,
                      LoginErrorMessage.incorrectPassword => i10n.youMustWriteAValidEmail,
                      LoginErrorMessage.noUserFoundEmail => i10n.youMustWriteAValidEmail,
                      LoginErrorMessage.generalError => i10n.youMustWriteAValidEmail,
                    };
                    showDialog(
                      context: context, 
                      builder: (ctx){
                        return Dialog(
                          child: FittedBox(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i10n.errorLogin,
                                    style: textTheme.headlineLarge,
                                  ),
                                  const SizedBox(height: 25,),
                                  Text(
                                    message,
                                    style: textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 25,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: ()=>Navigator.of(context).pop(), 
                                        child: Text(
                                          i10n.ok,
                                          style: textTheme.bodyLarge!.copyWith(color: colorScheme.primary),
                                        )
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        );
                      }
                    );
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    final bool isLoading = state is LoginCheckingState;
                    return Column(
                      children: [
                        Expanded(
                          flex: isKeyboardOpen ? 0 : 3,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            child: isKeyboardOpen ? const SizedBox() : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Column(
                              children: [
                                const Spacer(flex: 1,),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    i10n.welcomeBack.replaceAll(' ', '\n'),
                                    style: textTheme.displayMedium!.copyWith(color: colorScheme.onPrimary),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    i10n.wereHappyToSeeYouAgain,
                                    style: textTheme.bodyLarge!.copyWith(color: colorScheme.onPrimary),
                                  ),
                                ),
                                const Spacer(flex: 7,),
                              ],
                            ),
                          ),),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            decoration: BoxDecoration(
                                color: colorScheme.onPrimary,
                                borderRadius:
                                    const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 45.0),
                              child: Column(
                                children: [
                                  const Spacer(
                                    flex: 6,
                                  ),
                                  AuthField(
                                    icon: const Icon(Ionicons.person),
                                    labelText: i10n.emailLabel,
                                    hintText: i10n.emailHintText,
                                    editable: !isLoading,
                                    controller: emailController,
                                  ),
                                  const Spacer(),
                                  AuthField(
                                      icon: const Icon(Ionicons.lock_closed),
                                      labelText: i10n.passwordLabel,
                                      hintText: i10n.passwordHintText,
                                      password: true,
                                      editable: !isLoading,
                                      controller: passwordController),
                                  const Spacer(
                                    flex: 7,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                        onPressed: !isLoading
                                            ? () => _loginHandler(context, bloc)
                                            : null,
                                        style: ButtonStyle(
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                            backgroundColor: WidgetStatePropertyAll(colorScheme.secondary)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: !isLoading
                                              ? Text(
                                                  i10n.login,
                                                  style: textTheme.titleLarge!.copyWith(color: colorScheme.onSecondary),
                                                )
                                              : CircularProgressIndicator(
                                                  color: colorScheme.onSecondary,
                                                ),
                                        )),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(i10n.dontHaveAnAccountYetQuestion),
                                      TextButton(
                                        onPressed: ()=>context.pushReplacement(routeRegisterPage), 
                                        child: Text(i10n.registerHere)
                                      )
                                    ],
                                  ),
                                  const Spacer(
                                    flex: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginHandler(BuildContext context, LoginBloc bloc) async{
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      bloc.login(emailController.text, passwordController.text, '${androidInfo.brand} ${ androidInfo.model} ${androidInfo.device}', 'ANDROID');
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      bloc.login(emailController.text, passwordController.text, '${iosInfo.model} ${iosInfo.name}', 'IOS');
    } else {
      bloc.login(emailController.text, passwordController.text, 'UNKNOWN', 'WEB');
    }
  }
}

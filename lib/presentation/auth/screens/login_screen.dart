import 'package:couples_client_app/presentation/auth/bloc/login_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
    return SafeArea(
      child: Container(
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
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if(state is LoginFailedState){
                final String message = switch(state.message){
                  LoginMessage.emptyFields =>  i10n.youMustFillAllFields,
                  LoginMessage.nonExistingEmail =>  i10n.youMustWriteAValidEmail,
                  _ => i10n.anErrorOcurred,
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
                                const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))),
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
                                editable: state is! LoginCheckingState,
                                controller: emailController,
                              ),
                              const Spacer(),
                              AuthField(
                                  icon: const Icon(Ionicons.lock_closed),
                                  labelText: i10n.passwordLabel,
                                  hintText: i10n.passwordHintText,
                                  password: true,
                                  editable: state is! LoginCheckingState,
                                  controller: passwordController),
                              const Spacer(
                                flex: 7,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: state is! LoginCheckingState
                                        ? () => bloc.login(emailController.text, passwordController.text)
                                        : null,
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                        backgroundColor: WidgetStatePropertyAll(colorScheme.secondary)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: state is! LoginCheckingState
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
                                  Text("Don't have an account yet?"),
                                  TextButton(onPressed: () {}, child: Text('Register here!'))
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
      ),
    );
  }
}

import 'package:couples_client_app/presentation/auth/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:ionicons/ionicons.dart';


class LoginScreen extends StatefulWidget{
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late final TextEditingController emailController;
  late final TextEditingController passwordController;


  @override 
  void initState(){
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
          appBar: AppBar(
            backgroundColor: Colors.transparent
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
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
                      )
                    ],
                  ),
                )
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:  45.0),
                    child: Column(
                      children: [
                        const Spacer(flex: 6,),
                        AuthField(
                          icon: const Icon(Ionicons.person),
                          labelText: i10n.emailLabel,
                          hintText: i10n.emailHintText,
                        ),
                        const Spacer(),
                        AuthField(
                          icon: const Icon(Ionicons.lock_closed),
                          labelText: i10n.passwordLabel,
                          hintText: i10n.passwordHintText,
                          password: true,
                        ),
                        const Spacer(flex: 7,),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: (){}, 
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                )
                              ),
                              backgroundColor: WidgetStatePropertyAll(colorScheme.secondary)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                i10n.login,
                                style: textTheme.titleLarge!.copyWith(
                                  color: colorScheme.onSecondary
                                ),
                              ),
                            )
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account yet?"),
                            TextButton(
                              onPressed: (){}, 
                              child: Text('Register here!')
                            )
                          ],
                        ),
                        const Spacer(flex: 4,),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
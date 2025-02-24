import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/bloc/login_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/auth_field.dart';
import 'package:couples_client_app/presentation/auth/widgets/google_auth_button.dart';
import 'package:couples_client_app/presentation/auth/widgets/or_divider.dart';
import 'package:couples_client_app/shared/dialogs/error_dialog.dart';
import 'package:couples_client_app/shared/dialogs/success_dialog.dart';
import 'package:couples_client_app/shared/widgets/gradient_background.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final AnimationController _animationController;
  late final Animation<double> _expandedAnimation;


  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _expandedAnimation = Tween<double>(begin:1, end:32).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: Curves.easeOut
      )
    );
    super.initState();
    _animationController.forward().whenCompleteOrCancel((){

    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final i10n = AppLocalizations.of(context)!;
    final bloc = BlocProvider.of<LoginBloc>(context);
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return GradientBackground(
      startColor: colorScheme.primary,
      endColor: colorScheme.tertiary,
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
                    showDialog(
                      barrierDismissible: false,
                      context: context, 
                      builder: (ctx){
                        return SuccessDialog(
                          callback: () {
                            switch(state.message){
                              case LoginNavigateMessage.goToUserCreation: context.go(routeLogUserPage);break;
                              case LoginNavigateMessage.goToCoupleConnection: context.go(routeConnectCouplePage);break;
                              case LoginNavigateMessage.goToMainPage: context.go(routeMainPage);break;
                            }
                          },
                        );
                      }
                    );
                  }
                  if(state is LoginFailedState){
                    final String message = switch(state.message){
                      LoginErrorMessage.emptyFields =>  i10n.youMustFillAllFields,
                      LoginErrorMessage.invalidEmail =>  i10n.youMustWriteAValidEmail,
                      LoginErrorMessage.incorrectPassword => i10n.incorrectPassword,
                      LoginErrorMessage.noUserFoundEmail => i10n.noUserFoundEmail,
                      LoginErrorMessage.generalError => i10n.generalErrorLogin,
                    };
                    showDialog(
                      context: context, 
                      builder: (ctx){
                        return ErrorDialog(
                          tittle:  i10n.errorLogin, 
                          error: message, 
                          okText:  i10n.ok
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
                          flex: isKeyboardOpen ? 0 : 12,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            child: isKeyboardOpen ? const SizedBox() : LoginHeader(i10n: i10n, textTheme: textTheme, colorScheme: colorScheme),),
                        ),
                        AnimatedBuilder(
                          animation: _animationController,
                          child: Container(
                                decoration: BoxDecoration(
                                    color: colorScheme.onPrimary,
                                    borderRadius:
                                        const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                      const Spacer(),
                                      OrDivider(orText: i10n.or),
                                      const Spacer(),
                                      GoogleAuthButton(
                                        text: i10n.loginWithGoogle, 
                                        handler: (){}
                                      ),
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
                                      Wrap(
                                        direction: Axis.horizontal,
                                        crossAxisAlignment: WrapCrossAlignment.center,
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
                          builder: (context, child) {
                            return Expanded(
                              flex: _expandedAnimation.value.toInt(),
                              child: child!,
                            );
                          }
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
      late final String brand, model, device;
      try{
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        brand = androidInfo.brand;
        model = androidInfo.model;
        device = androidInfo.device;
      }catch(error){
        brand = "UNKNOWN";
        model = "UNKNOWN";
        device = "UNKNOWN";
      }
      bloc.login(emailController.text, passwordController.text, '$brand $model $device', 'ANDROID');
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      late final String model, name;
      try{
       IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        model = iosInfo.model;
        name = iosInfo.name;
      }catch(error){
        model = "UNKNOWN";
        name = "UNKNOWN";
      }
      bloc.login(emailController.text, passwordController.text, '$model $name', 'IOS');
    } else {
      bloc.login(emailController.text, passwordController.text, 'UNKNOWN', 'WEB');
    }
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.i10n,
    required this.textTheme,
    required this.colorScheme,
  });

  final AppLocalizations i10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: Column(
      children: [
        const Spacer(flex: 1,),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            i10n.welcomeBack.replaceAll(' ', '\n'),
            style: textTheme.displayMedium!.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold
            ),
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
    );
  }
}

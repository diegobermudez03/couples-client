import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/bloc/register_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/auth_field.dart';
import 'package:couples_client_app/presentation/auth/widgets/google_auth_button.dart';
import 'package:couples_client_app/presentation/auth/widgets/or_divider.dart';
import 'package:couples_client_app/shared/dialogs/error_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final i10n = AppLocalizations.of(context)!;
    final bloc = BlocProvider.of<RegisterBloc>(context);
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
              child: BlocListener<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if(state is RegisterSuccessState){
                    context.go(routeLogUserPage);
                  }
                  if(state is RegsiterFailedState){
                    final String message = switch(state.message){
                      RegisterErrorMessage.emptyFields =>  i10n.youMustFillAllFields,
                      RegisterErrorMessage.invalidEmail =>  i10n.youMustWriteAValidEmail,
                      RegisterErrorMessage.notEqualsPassword => i10n.notEqualsPasswords,
                      RegisterErrorMessage.insecurePassword => i10n.insecurePassword,
                      RegisterErrorMessage.emailAlreadyUsed => i10n.emailAlreadyInUse,
                      RegisterErrorMessage.genericError => i10n.generalErrorLogin,
                    };
                    showDialog(
                      context: context, 
                      builder: (ctx){
                        return ErrorDialog(
                          tittle: i10n.errorRegister, 
                          error: message, 
                          okText: i10n.ok
                        );
                      }
                    );
                  }
                },
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    final bool isLoading = state is RegisterCheckingState;
                    return Column(
                      children: [
                        Expanded(
                          flex: isKeyboardOpen ? 0 : 1,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            child: isKeyboardOpen ? const SizedBox() : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                            child: Column(
                              children: [
                                const Spacer(flex: 1,),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    i10n.hello,
                                    style: textTheme.displayMedium!.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    i10n.registerToGetStarted,
                                    style: textTheme.bodyLarge!.copyWith(color: colorScheme.onPrimary),
                                  ),
                                ),
                                const Spacer(flex: 7,),
                              ],
                            ),
                          ),),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                                color: colorScheme.onPrimary,
                                borderRadius:
                                    const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35.0),
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
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      i10n.passwordMustHaveRules,
                                      style: textTheme.labelMedium,
                                    )
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
                                  AuthField(
                                      icon: const Icon(Ionicons.lock_closed),
                                      labelText: i10n.confirmPasswordLabel,
                                      hintText: i10n.confirmPasswordHint,
                                      password: true,
                                      editable: !isLoading,
                                      controller: confirmPasswordController),
                                  const Spacer(),
                                  OrDivider(orText:  i10n.or),
                                  const Spacer(),
                                  GoogleAuthButton(
                                    text: i10n.registerWithGoogle, 
                                    handler: (){}
                                  ),
                                  const Spacer(
                                    flex: 7,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                        onPressed: ()=>_registerHandler(context, bloc),
                                        style: ButtonStyle(
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                            backgroundColor: WidgetStatePropertyAll(colorScheme.secondary)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: !isLoading
                                              ? Text(
                                                  i10n.register,
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
                                      Text(i10n.alreadyHaveAnAccountQuestion),
                                      TextButton(onPressed: () => context.pushReplacement(routeLoginPage), child: Text(i10n.loginHere))
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

  void _registerHandler(BuildContext context, RegisterBloc bloc) async{
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
      bloc.register(emailController.text, passwordController.text,confirmPasswordController.text , '$brand $model $device', 'ANDROID');
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
      bloc.register(emailController.text, passwordController.text,confirmPasswordController.text, '$model $name', 'IOS');
    } else {
      bloc.register(emailController.text, passwordController.text,confirmPasswordController.text, 'UNKNOWN', 'WEB');
    }
  }
}

import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/bloc/create_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/submit_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/code.dart';
import 'package:couples_client_app/shared/dialogs/error_dialog.dart';
import 'package:couples_client_app/shared/widgets/dialog_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ConnectCoupleScreen extends StatefulWidget {
  const ConnectCoupleScreen({super.key});

  @override
  State<ConnectCoupleScreen> createState() => _ConnectCoupleScreenState();
}

class _ConnectCoupleScreenState extends State<ConnectCoupleScreen> {
  late final DateRangePickerController dateController;
  late final TextEditingController codeController;

  @override
  void initState() {
    dateController = DateRangePickerController();
    codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary], begin: Alignment.topCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                  flex: isKeyboardOpen ? 0 : 2,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isKeyboardOpen
                        ? const SizedBox()
                        : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              l10n.timeToPairUpWithYourPartner,
                              style: textTheme.displaySmall!
                                  .copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                            ),
                        ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          isKeyboardOpen
                              ? const SizedBox()
                              : Expanded(
                                  flex: 12,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: colorScheme.surfaceBright,
                                      ),
                                      child: BlocListener<CreateCodeBloc, CreateCodeState>(
                                        listener: (context, state) {
                                          if(state is CreateCodeFailedState){
                                            if(state.message == CreateCodeErrorMessages.alreadyHasCouple){
                                              context.go(routeMainPage);
                                            }else{
                                              final message = switch(state.message){
                                                CreateCodeErrorMessages.noActiveUser => l10n.noActiveUserForCouple,
                                                CreateCodeErrorMessages.generalError => l10n.genericErrorCreatingCode,
                                                CreateCodeErrorMessages.alreadyHasCouple =>  l10n.genericErrorCreatingCode
                                              };
                                              showDialog(context: context, builder: (ctx){
                                                return ErrorDialog(
                                                  tittle: l10n.errorCreatingVinculationCode, 
                                                  error: message, 
                                                  okText: l10n.ok
                                                );
                                              });
                                            }
                                          }
                                          if(state is CreateCodeConnectedState){
                                            context.go(routePartnerNicknamePage);
                                          }
                                        },
                                        child: BlocBuilder<CreateCodeBloc, CreateCodeState>(
                                          builder: (context, state) {
                                            final bloc = BlocProvider.of<CreateCodeBloc>(context);
                                            return Column(
                                              children: [
                                                const Spacer(
                                                  flex: 3,
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(
                                                    l10n.inviteYourPartner,
                                                    style:
                                                        textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                const Spacer(
                                                  flex: 1,
                                                ),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(state is! CreateCodeExistsState
                                                      ? l10n.generateCodeBySelectingTheDateYouBecameACouple
                                                      : l10n.ifYouModifyTheDateTheCodeWillBeUpdated,
                                                      style:  textTheme.labelMedium,
                                                    ),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton.icon(
                                                    style: ButtonStyle(
                                                      backgroundColor: WidgetStatePropertyAll(colorScheme.tertiary),
                                                      elevation: const  WidgetStatePropertyAll(2),
                                                      iconColor: WidgetStatePropertyAll(colorScheme.onTertiary),
                                                      iconSize: const WidgetStatePropertyAll(25),
                                                      shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                        )
                                                      )
                                                    ),
                                                    label: Padding(
                                                      padding: const EdgeInsets.all(16.0),
                                                      child: Text(
                                                        state is! CreateCodeExistsState
                                                            ? l10n.selectYourAnniversary
                                                            : '${l10n.anniversary} ${DateFormat("dd/MM/yyyy").format(state.tempCouple.startDate)}',
                                                        style: textTheme.labelLarge?.copyWith(
                                                          color: colorScheme.onTertiary,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () => _showDatePicker(context, bloc),
                                                    icon: const FaIcon(FontAwesomeIcons.calendar)
                                                  ),
                                                ),
                                                const Spacer(
                                                  flex: 1,
                                                ),
                                                const Spacer(
                                                  flex: 1,
                                                ),
                                                state is CreateCodeCheckingState
                                                    ? const Center(child: CircularProgressIndicator())
                                                    : (state is CreateCodeExistsState
                                                        ? Code(code: state.tempCouple.code)
                                                        : const SizedBox()),
                                                const Spacer(
                                                  flex: 5,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )),
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                              flex: 12,
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal:  25.0),
                                  decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: colorScheme.surfaceBright,
                                      ),
                                  child: BlocListener<SubmitCodeBloc, SubmitCodeState>(
                                    listener: (context, state) {
                                      if (state is SubmitCodeSuccess) {
                                        context.go(routePartnerNicknamePage);
                                      }
                                      else if(state is SubmitCodeFailed){
                                        if(state.message == SubmitCodeErrorMessage.alreadyHasCouple){
                                           context.go(routeMainPage);
                                        }else{
                                          final message = switch(state.message){
                                            SubmitCodeErrorMessage.onlyDigits => l10n.theCodeMustOnlyContainDigits,
                                            SubmitCodeErrorMessage.nonExistingCode => l10n.theCodeDoesntExist,
                                            SubmitCodeErrorMessage.cantVinculateWithYourself => l10n.youCantVinculateWithYourself,
                                            _ => l10n.genericErrorVinculating
                                          };
                                          showDialog(context: context, builder: (ctx)=>ErrorDialog(
                                            tittle: l10n.errorVinculating, 
                                            error: message, 
                                            okText: l10n.ok
                                            )
                                          );
                                        }
                                      }
                                    },
                                    child: BlocBuilder<SubmitCodeBloc, SubmitCodeState>(
                                      builder: (context, state) {
                                        bool allowSubmit = codeController.text.length == 5;
                                        final bloc = BlocProvider.of<SubmitCodeBloc>(context);
                                        return StatefulBuilder(builder: (context, stateSetter) {
                                          return Column(
                                            children: [
                                              const Spacer(
                                                flex: 3,
                                              ),
                                              Text(
                                                l10n.enterYourPartnersCode,
                                                style: textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  Expanded(
                                                    flex: 5,
                                                    child: TextField(
                                                      controller: codeController,
                                                      textAlign: TextAlign.center,
                                                      style: textTheme.displayMedium,
                                                      onChanged: (value) {
                                                        if (value.length >= 5 && !allowSubmit) {
                                                          stateSetter(
                                                            () => allowSubmit = true,
                                                          );
                                                        }
                                                        if (value.length < 5 && allowSubmit) {
                                                          stateSetter(() => allowSubmit = false);
                                                        }
                                                      },
                                                      decoration: InputDecoration(
                                                          enabled: state is! SubmitCodeLoading,
                                                          border: const OutlineInputBorder(),
                                                          contentPadding: const EdgeInsets.all(10),
                                                          hintText: "XXXXX",
                                                          isCollapsed: true,
                                                          fillColor: colorScheme.tertiaryContainer,
                                                          filled: true),
                                                      keyboardType: TextInputType.number,
                                                      maxLength: 5,
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  AnimatedElevatedButton(
                                                    icon: const FaIcon(FontAwesomeIcons.heart),
                                                    label: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                                          child: state is SubmitCodeLoading
                                                            ? CircularProgressIndicator(color: colorScheme.onTertiary,)
                                                            : Text(l10n.vinculate, style: textTheme.labelLarge?.copyWith(
                                                              color: colorScheme.onTertiary,
                                                              fontWeight: FontWeight.bold
                                                            ),),
                                                        ),
                                                    onPressed: allowSubmit ? () => bloc.submitCode(codeController.text) : (){},
                                                  )
                                                 /* Expanded(
                                                    flex: 5,
                                                    child: ElevatedButton.icon(
                                                        onPressed:
                                                            allowSubmit ? () => bloc.submitCode(codeController.text) : null,
                                                        icon: const FaIcon(FontAwesomeIcons.heart),
                                                        label: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                                          child: state is SubmitCodeLoading
                                                            ? CircularProgressIndicator(color: colorScheme.onTertiary,)
                                                            : Text(l10n.vinculate, style: textTheme.labelLarge?.copyWith(
                                                              color: colorScheme.onTertiary,
                                                              fontWeight: FontWeight.bold
                                                            ),),
                                                        ),
                                                        style: ButtonStyle(
                                                            textStyle: WidgetStatePropertyAll(textTheme.labelLarge!.copyWith(color: colorScheme.onTertiary)),
                                                            backgroundColor: WidgetStatePropertyAll(colorScheme.tertiary),
                                                            elevation: const WidgetStatePropertyAll(2),
                                                            iconColor: WidgetStatePropertyAll(colorScheme.onTertiary),
                                                            iconSize: const WidgetStatePropertyAll(25),
                                                            shape: WidgetStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10)
                                                              )
                                                            )
                                                            
                                                          ),
                                                    ),
                                                  ),*/,
                                                  const Spacer(),
                                                ],
                                              ),
                                              const Spacer(
                                                flex: 2,
                                              ),
                                            ],
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )),
                          
                        ],
                      ),
                      !isKeyboardOpen
                          ? Align(
                              alignment: Alignment.center,
                              heightFactor: 11,
                              child: Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Color.lerp(colorScheme.primary, colorScheme.secondary, 0.75),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  l10n.orYouCanAlso,
                                  style: textTheme.titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                                ),
                              ))
                          : const SizedBox()
                    ],
                  ),
                ),
                isKeyboardOpen ? const SizedBox(): Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton.icon(
                      onPressed: () => context.go(routeWelcomePage),
                      icon: RiveAnimatedIcon(
                        onTap: ()=> context.go(routeWelcomePage),
                        loopAnimation: true,
                        height: 35,
                        width: 35,
                        riveIcon: RiveIcon.backward,
                        color: colorScheme.onErrorContainer,
                      ),
                      label: Text(l10n.exitLogout, style: textTheme.labelLarge?.copyWith(color: colorScheme.onErrorContainer),),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(colorScheme.errorContainer)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, CreateCodeBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: 400,
            width: 500,
            child: DialogCalendarWidget(
              controller: dateController,
              maxDate: DateTime.now(),
              onSelectionChanged: (_) {},
              onSubmit: (object) {
                bloc.generateCode(object as DateTime);
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}



class AnimatedElevatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget label;
  final Widget icon;

  const AnimatedElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  State<AnimatedElevatedButton> createState() => _AnimatedElevatedButtonState();
}

class _AnimatedElevatedButtonState extends State<AnimatedElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: -10).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    // Ejecutar la animación primero
    await _controller.forward();
    await _controller.reverse();
    // Luego llamar al callback original
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: ElevatedButton.icon(
            onPressed: _handlePress,
            icon: widget.icon,
            label: widget.label,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        );
      },
    );
  }
}

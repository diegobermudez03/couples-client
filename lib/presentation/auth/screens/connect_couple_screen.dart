import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/bloc/create_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/submit_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/code.dart';
import 'package:couples_client_app/shared/dialogs/error_dialog.dart';
import 'package:couples_client_app/shared/dialogs/success_dialog.dart';
import 'package:couples_client_app/shared/widgets/dialog_calendar_widget.dart';
import 'package:couples_client_app/shared/widgets/gradient_background.dart';
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

class _ConnectCoupleScreenState extends State<ConnectCoupleScreen> with SingleTickerProviderStateMixin{
  late final DateRangePickerController dateController;
  late final TextEditingController codeController;
  late final AnimationController _animationController;
  late final Animation<double>  _cardsAnimation;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    dateController = DateRangePickerController();
    codeController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600)
    );
    _cardsAnimation = Tween<double>(begin: 500, end: 0).animate(_animationController);
    _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
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
    return GradientBackground(
      startColor: colorScheme.primary,
      endColor:  colorScheme.secondary,
      horizontal: false,
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
                        : ConnectCoupleHeader(l10n: l10n, textTheme: textTheme, colorScheme: colorScheme),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    child:  Stack(
                      children: [
                        Column(
                          children: [
                            isKeyboardOpen ? const SizedBox() : 
                            ConnectCard(
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
                                    showDialog(
                                      context: context, 
                                      barrierDismissible: false,
                                      builder: (ctx)=>SuccessDialog(
                                        callback: ()=>context.go(routePartnerNicknamePage),
                                      )
                                    );
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
                                        _CalendarButton(controller: bloc, dateController: dateController, state: state,),
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
                            const Spacer(
                              flex: 1,
                            ),
                            ConnectCard(
                              child: BlocListener<SubmitCodeBloc, SubmitCodeState>(
                                listener: (context, state) {
                                  if (state is SubmitCodeSuccess) {
                                    showDialog(
                                      context: context, 
                                      barrierDismissible: false,
                                      builder: (ctx)=>SuccessDialog(
                                        callback: ()=>context.go(routePartnerNicknamePage),
                                      )
                                    );
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
                                              Expanded(
                                                flex: 5,
                                                child: AnimatedElevatedButton(
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
                                                  onPressed: allowSubmit ? () => bloc.submitCode(codeController.text) : null,
                                                ),
                                              ),
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
                          ],
                        ),
                        !isKeyboardOpen
                            ? OrYouCanAlsoWidget(colorScheme: colorScheme, l10n: l10n, textTheme: textTheme)
                            : const SizedBox()
                      ],
                    ),
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()..translate(_cardsAnimation.value, 0, 0)..scale(_sizeAnimation.value, 1, 1),
                        //offset: Offset(_cardsAnimation.value, 0),
                        child: child!,
                      );
                    }
                  ),
                ),
                isKeyboardOpen ? const SizedBox(): ExitButtonWidget(colorScheme: colorScheme, l10n: l10n, textTheme: textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class ExitButtonWidget extends StatelessWidget {
  const ExitButtonWidget({
    super.key,
    required this.colorScheme,
    required this.l10n,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final AppLocalizations l10n;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class OrYouCanAlsoWidget extends StatelessWidget {
  const OrYouCanAlsoWidget({
    super.key,
    required this.colorScheme,
    required this.l10n,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final AppLocalizations l10n;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Align(
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
        ));
  }
}

class ConnectCoupleHeader extends StatelessWidget {
  const ConnectCoupleHeader({
    super.key,
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
  });

  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
          l10n.timeToPairUpWithYourPartner,
          style: textTheme.displaySmall!
              .copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
        ),
    );
  }
}



class AnimatedElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
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
      duration: const Duration(milliseconds: 200),
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
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: ElevatedButton.icon(
            onPressed: widget.onPressed == null? null :  _handlePress,
            icon: widget.icon,
            label: widget.label,
            style: ButtonStyle(
              textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
              elevation: const WidgetStatePropertyAll(2),
              iconColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onTertiary),
              iconSize: const WidgetStatePropertyAll(25),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              )
              
            ),
          ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child!,
        );
      },
    );
  }
}


class ConnectCard extends StatelessWidget{

  final Widget child;
  const ConnectCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
          child: child,
        )
      )
    );
  }
}


class _CalendarButton extends StatelessWidget{

  final CreateCodeBloc controller;
  final CreateCodeState state;
  final DateRangePickerController dateController;

  const _CalendarButton({
    required this.controller,
    required this.state,
    required this.dateController
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    return  SizedBox(
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
                : '${l10n.anniversary} ${DateFormat("dd/MM/yyyy").format((state as CreateCodeExistsState).tempCouple.startDate)}',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onTertiary,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        onPressed: () => _showDatePicker(context, controller),
        icon: const FaIcon(FontAwesomeIcons.calendar)
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
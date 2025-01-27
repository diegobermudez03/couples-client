import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/bloc/create_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/submit_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/code.dart';
import 'package:couples_client_app/shared/widgets/dialog_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(onPressed: () {}, child: Text('Exit')),
                ),
                Expanded(
                  flex: isKeyboardOpen ? 0 : 1,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: isKeyboardOpen
                        ? const SizedBox()
                        : Text(
                            'Lets pair ywith your partner!',
                            style: textTheme.displaySmall!
                                .copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                          ),
                  ),
                ),
                Expanded(
                  flex: 6,
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
                                    child: Card(
                                      color: colorScheme.surfaceBright,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                                    'Invite your partner',
                                                    style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                const Spacer(
                                                  flex: 3,
                                                ),
                                                Text(state is! CreateCodeExistsState
                                                    ? 'GENERATE CODE by selecting your start date'
                                                    : "If you modify the met date you'll generate  a new code"),
                                                OutlinedButton.icon(
                                                    label: Text(
                                                      state is! CreateCodeExistsState
                                                          ? 'select your annniversary'
                                                          : 'Aniversary ${DateFormat("dd/MM/yyyy").format(state.tempCouple.startDate!)}',
                                                      style: textTheme.labelSmall,
                                                    ),
                                                    onPressed: () => _showDatePicker(context, bloc),
                                                    icon: FaIcon(FontAwesomeIcons.calendar)),
                                                const Spacer(
                                                  flex: 3,
                                                ),
                                                const Spacer(
                                                  flex: 3,
                                                ),
                                                state is CreateCodeCheckingState || state is CreateCodeCheckingState
                                                    ? const Center(child: CircularProgressIndicator())
                                                    : (state is CreateCodeExistsState
                                                        ? Code(code: state.tempCouple.code)
                                                        : const SizedBox()),
                                                const Spacer(
                                                  flex: 3,
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
                                child: Card(
                                  color: colorScheme.surfaceBright,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BlocListener<SubmitCodeBloc, SubmitCodeState>(
                                      listener: (context, state) {
                                        if(state is SubmitCodeSuccess){
                                           context.go(routePartnerNicknamePage);
                                        }
                                      },
                                      child: BlocBuilder<SubmitCodeBloc, SubmitCodeState>(
                                        builder: (context, state) {
                                          bool allowSubmit = false;
                                          final bloc = BlocProvider.of<SubmitCodeBloc>(context);
                                          return StatefulBuilder(builder: (context, stateSetter) {
                                            return Column(
                                              children: [
                                                const Spacer(),
                                                Text(
                                                  'Enter your partners Code',
                                                  style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                                                ),
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
                                                            border: OutlineInputBorder(),
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
                                                TextButton(
                                                    onPressed:
                                                        allowSubmit ? () => bloc.submitCode(codeController.text) : null,
                                                    child: state is SubmitCodeLoading
                                                        ? const CircularProgressIndicator()
                                                        : Text("Vinculate")),
                                                const Spacer(),
                                              ],
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          const Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      !isKeyboardOpen
                          ? Align(
                              alignment: Alignment.center,
                              heightFactor: 11,
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(),
                                ),
                                child: Text(
                                  'Or you can also',
                                  style: textTheme.titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                                ),
                              ))
                          : const SizedBox()
                    ],
                  ),
                )
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

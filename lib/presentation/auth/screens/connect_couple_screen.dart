import 'package:couples_client_app/presentation/auth/bloc/create_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/bloc/submit_code_bloc.dart';
import 'package:couples_client_app/presentation/auth/widgets/code.dart';
import 'package:couples_client_app/shared/widgets/dialog_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ConnectCoupleScreen extends StatefulWidget {
  @override
  State<ConnectCoupleScreen> createState() => _ConnectCoupleScreenState();
}

class _ConnectCoupleScreenState extends State<ConnectCoupleScreen> {
  late final DateRangePickerController dateController;
  DateTime? selectedDate;

  @override
  void initState() {
    dateController = DateRangePickerController();
    super.initState();
  }

  @override 
  void dispose() {
    dateController.dispose();
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
          gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary], begin: Alignment.topCenter)),
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
                            style: textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child:Column(
                    children: [
                      isKeyboardOpen ? const SizedBox(): Expanded(
                          flex: 12,
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: colorScheme.surfaceBright,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: BlocBuilder<CreateCodeBloc, CreateCodeState>(
                                  builder: (context, state) {
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
                                        Text(
                                          selectedDate == null ? 'Select the date you met to generate the code' :
                                          "If you modify the met date you'll generate  a new code"
                                        ),
                                        OutlinedButton.icon(
                                          label: Text(
                                            selectedDate  == null ? 'select your annniversary' : 'Aniversary ${DateFormat("dd/MM/yyyy").format(selectedDate!)}',
                                            style: textTheme.labelSmall,
                                          ),
                                          onPressed: () => _showDatePicker(context),
                                          icon: FaIcon(FontAwesomeIcons.calendar)
                                        ),
                                        const Spacer(
                                          flex: 3,
                                        ),
                                        const Spacer(
                                          flex: 3,
                                        ),
                                        state is CreateCodeExistsState ? Code(code: state.tempCouple.code) : const SizedBox(),
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
                                child: BlocBuilder<SubmitCodeBloc, SubmitCodeState>(
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        Text('Already have a code?'),
                                        const TextField()
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

   void _showDatePicker(BuildContext context) {
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
              setState: ()=>setState(() {}), 
              maxDate: DateTime.now(),
              onSelectionChanged:(DateRangePickerSelectionChangedArgs args) {
                selectedDate = args.value;
              },
            ),
          ),
        );
      },
    );
  }
}

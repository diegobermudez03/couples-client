import 'package:couples_client_app/presentation/auth/widgets/user_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateUserScreen extends StatefulWidget{

  const CreateUserScreen({super.key});
  
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final DateRangePickerController dateController;
  DateTime? selectedDate;
  bool? male;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    dateController = DateRangePickerController();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 10,
                color: colorScheme.onPrimary,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40) )
                      ),
                      child: Column(
                        children: [
                          const Spacer(flex: 2,),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              l10n.letsKnowAboutYou,
                              style: textTheme.displaySmall,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              l10n.weNeedToKnowALittleAboutYouBeforeConnecting,
                              style: textTheme.labelLarge,
                            ),
                          ),
                          const Spacer(flex: 2,),
                          UserField(
                            hintText: l10n.firstName, 
                            labelText: l10n.enterYourFirstName, 
                            controller: firstNameController, 
                            editable: true
                          ),
                          const Spacer(flex: 2,),
                          UserField(
                            hintText: l10n.enterYourLastname, 
                            labelText: l10n.lastName, 
                            controller: lastNameController, 
                            editable: true
                          ),
                          const Spacer(flex: 2,),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(l10n.selectYourBirthdate)
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                              ),
                              onPressed: () => _showDatePicker(context),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedDate == null ? l10n.selectDate : DateFormat('dd/MM/yyyy').format(selectedDate!)
                                    ),
                                    const Spacer(),
                                    const FaIcon(
                                      FontAwesomeIcons.calendar,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 2,),
                          Text(l10n.selectYourGender),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 50,
                              child: ToggleButtons(
                                borderWidth: 2,
                                borderColor: const Color.fromARGB(78, 0, 0, 0),
                                borderRadius: BorderRadius.circular(30),
                               // selectedColor: colorScheme.primaryContainer,
                                fillColor:colorScheme.primaryContainer, 
                                //color: colorScheme.secondaryContainer,
                                //fillColor: colorScheme.onPrimaryContainer,
                                isSelected: [male != null ? male! : false, male != null ? !male! : false],
                                onPressed: (i){
                                  setState(() {
                                    male = i==0;
                                  });
                                },
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width/3, 
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'images/icons/minimistBoyGhost.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Text(l10n.male),
                                        const Spacer(flex: 2,),
                                      ],
                                    )
                                  ),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width/3, 
                                    child: Row(
                                      children: [
                                        const Spacer(flex: 2,),
                                        Text(l10n.female),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'images/icons/minimistGirlGhost.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    )
                                  )
                                ], 
                              ),
                            ),
                          ),
                          const Spacer(flex: 3,),
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                onPressed: (){},
                                style: ButtonStyle(
                                  shape: const WidgetStatePropertyAll(StadiumBorder()),
                                  backgroundColor: WidgetStatePropertyAll(colorScheme.tertiaryFixedDim)
                                ), 
                                child: Row(
                                  children: [
                                    const RiveAnimatedIcon(
                                      loopAnimation: true,
                                      height: 40,
                                      width: 40,
                                      riveIcon: RiveIcon.backward,
                                    ),
                                    Text(l10n.exitLogout)
                                  ],
                                )
                              ),
                              const Spacer(flex: 10,),
                              TextButton(
                                onPressed: (){},
                                style: ButtonStyle(
                                  shape: const WidgetStatePropertyAll(StadiumBorder()),
                                  backgroundColor: WidgetStatePropertyAll(colorScheme.primaryFixedDim)
                                ), 
                                child: Row(
                                  children: [
                                    Text(l10n.next),
                                    const RiveAnimatedIcon(
                                      loopAnimation: true,
                                      height: 35,
                                      width: 35,
                                      riveIcon: RiveIcon.forward,
                                    ),
                                  ],
                                )
                              ),
                              const Spacer(),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  ),
                  const Expanded(
                    child: SizedBox(),
                  )
                ],
              )
            )
          ],
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SfDateRangePicker(
                showNavigationArrow: true,
                view: DateRangePickerView.year,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer
                ),
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                confirmText: 'Ok',
                cancelText: 'CANCEL',
                minDate: DateTime(DateTime.now().year-80),
                maxDate: DateTime(DateTime.now().year-14),
                controller: dateController,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  selectedDate = args.value;
                },
                showActionButtons: true, 
                onSubmit: (_) {
                  Navigator.of(context).pop();
                  setState(() {}); 
                },
                onCancel: () {
                  Navigator.of(context).pop();
                  setState(() {}); 
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
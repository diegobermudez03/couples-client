import 'package:couples_client_app/presentation/auth/widgets/user_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateUserScreen extends StatefulWidget{

  
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
          colors: [colorScheme.secondary, colorScheme.tertiary]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: colorScheme.onPrimary,),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 10,
                color: colorScheme.onPrimary,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(65), bottomRight: Radius.circular(65) )
                      ),
                      child: Column(
                        children: [
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
                          const Spacer(),
                          UserField(
                            hintText: 'Firstname', 
                            labelText: 'Enter your first name', 
                            controller: firstNameController, 
                            editable: true
                          ),
                          const Spacer(),
                          UserField(
                            hintText: 'Enter your last name', 
                            labelText: 'Lastname', 
                            controller: lastNameController, 
                            editable: true
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('Select your birth date')
                          ),
                          Container(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                              ),
                              onPressed: () => _showDatePicker(context),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedDate == null ? 'Select date' : DateFormat('dd/MM/yyyy').format(selectedDate!)
                                    ),
                                    const Spacer(),
                                    FaIcon(
                                      FontAwesomeIcons.calendar,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text('Select your gender'),
                          Align(
                            alignment: Alignment.center,
                            child: ToggleButtons(
                              borderRadius: BorderRadius.circular(30),
                              selectedColor: colorScheme.primaryContainer,
                              fillColor: colorScheme.onPrimaryContainer,
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width/3, 
                                  child: Center(child: Text('Male'))
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width/3, 
                                  child: Center(child: Text('Female'))
                                )
                              ], 
                              isSelected: [male != null ? male! : false, male != null ? !male! : false],
                              onPressed: (i){
                                setState(() {
                                  if(i==0) male = true;
                                  else male = false;
                                });
                              },
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(onPressed: (){}, child: Text("back")),
                              const Spacer(flex: 6,),
                              TextButton(onPressed: (){}, child: Text("next")),
                               const Spacer(),
                            ],
                          ),
                           const Spacer(),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 5,
                          child: SizedBox()
                        ),
                        const Spacer(),
                      ],
                    ),
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
          content: SizedBox(
            height: 400,
            width: 400,
            child: SfDateRangePicker(
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
            ),
          ),
        );
      },
    );
  }
}
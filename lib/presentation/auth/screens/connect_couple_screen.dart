
import 'package:couples_client_app/presentation/auth/widgets/code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConnectCoupleScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primaryFixedDim, colorScheme.tertiaryFixedDim],
            begin: Alignment.topCenter
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:  16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: (){}, 
                      child: Text('Exit')
                    ),
                  ),
                  Expanded(
                    flex: isKeyboardOpen ? 0: 1,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isKeyboardOpen ? const SizedBox() : Column(
                        children: [
                          const Spacer(),
                          Text( 
                            'Lets pair ywith your partner!',
                            style: textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const Spacer(flex: 5,),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              flex: 12,
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: colorScheme.surfaceBright,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      children: [
                                        const Spacer(flex: 3,),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            'Invite your partner',
                                            style: textTheme.titleLarge!.copyWith(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        const Spacer(flex: 3,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'To geenrate the code please select the date you too met',
                                                style: textTheme.labelSmall,
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            Expanded(
                                              child: OutlinedButton.icon(
                                                label: Text(
                                                  'select your annniversary',
                                                  style: textTheme.labelSmall,
                                                ),
                                                onPressed: (){}, 
                                                icon: FaIcon(FontAwesomeIcons.calendar)
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(flex: 3,),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.symmetric(horizontal: 20),
                                          child: TextButton(
                                            onPressed: (){},
                                            style: ButtonStyle(
                                              backgroundColor: WidgetStatePropertyAll(colorScheme.tertiary),
                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)
                                              ))
                                            ), 
                                            child: Text(
                                              'Generate code',
                                              style: textTheme.bodyMedium!.copyWith(
                                                color: colorScheme.onTertiary,
                                                fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ),
                                        ),
                                        const Spacer(flex: 3,),
                                        Column(
                                          children: [
                                            Code(code: "12345"),
                                            OutlinedButton.icon(
                                              onPressed: (){}, 
                                              style: ButtonStyle(
                                                padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                                                minimumSize: WidgetStatePropertyAll(Size(0, 0)),
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8)
                                                  )
                                                )
                                              ),
                                              icon: Icon(
                                                Icons.copy
                                              ),
                                              label: Text(
                                                'Tap to copy',
                                                style: textTheme.labelSmall,
                                              )
                                            ),
                                          ],
                                        ),
                                        const Spacer(flex: 3,),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                            const Spacer(flex: 1,),
                            Expanded(
                              flex: 12,
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: colorScheme.surfaceBright,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('Already have a code?')
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                          const Spacer(flex: 1,),
                          ],
                        ),
                        Positioned(
                          left: MediaQuery.sizeOf(context).width/2.6,
                          top: MediaQuery.sizeOf(context).height/2.85,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration:  BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                l10n.or,
                                style: textTheme.headlineSmall!.copyWith(
                                  color: colorScheme.onSecondaryContainer
                                ),
                              ),
                            ),
                          ),
                        )
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
}
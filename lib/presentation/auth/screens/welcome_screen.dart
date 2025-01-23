import 'dart:async';

import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/presentation/auth/widgets/intro_page.dart';
import 'package:couples_client_app/shared/helpers/func_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final pageController = PageController();
  int currentPage = 0;
  Timer? autoScrollTimer;

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start the timer for auto-scroll
    autoScrollTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (pageController.hasClients) {
        int nextPage = (currentPage + 1) % 4; // Ensure it loops back to the first page
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          currentPage = nextPage;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final i10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primaryFixedDim, colorScheme.tertiaryFixedDim],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
            child: Image.asset(
              getAsset('images/general/app_title.png'),
              fit: BoxFit.fitHeight,
              height: 50,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              flex: 32,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom:  25, right: 25, left: 25),
                    child: PageView(
                      controller: pageController,
                      children: [
                        IntroPage(
                          lottieURL: getAsset('animations/intro/page1.json'),
                          tittle:i10n.introTitlePage1,
                          text: i10n.descIntroPage1,
                          righOrientation: false,
                        ),
                        IntroPage(
                          lottieURL: getAsset("animations/intro/page2.json"),
                          tittle: i10n.introTitlePage2,
                          text: i10n.descIntroPage2,
                          righOrientation: true,
                        ),
                        IntroPage(
                          lottieURL: getAsset("animations/intro/page3.json"),
                          tittle: i10n.introTitlePage3,
                          text: i10n.descIntroPage3,
                          righOrientation: false,
                        ),
                        IntroPage(
                          lottieURL: getAsset("animations/intro/page4.json"),
                          tittle: i10n.introTitlePage4,
                          text: i10n.descIntroPage4,
                          righOrientation: true,
                        ),
                      ],
                      onPageChanged: (value) => setState(() {
                        currentPage = value;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedSmoothIndicator(    
                        activeIndex: currentPage,    
                        count: 4,    
                        effect: WormEffect(
                          dotWidth: 12,
                          dotHeight: 12,
                          spacing: 15,
                          dotColor: colorScheme.surfaceContainerLowest,
                          activeDotColor: colorScheme.primary,
                        ), 
                        onDotClicked: (index) {
                          setState(() {
                            currentPage = index;
                          });
                          pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
                        },
                      ),
                    ),
                  ) 
                ],
              ),
            ),
            const Spacer(flex: 1,),
            Expanded(
              flex: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 3,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: ()=>context.push(routeLoginPage), 
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:  8.0),
                            child: Text(
                              i10n.login,
                              style: textTheme.titleLarge!.copyWith(
                                color: colorScheme.onPrimary
                              ),
                            ),
                          ),
                        )
                      ),
                    ),
                    const Spacer(flex: 1,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: (){}, 
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHighest),
                          elevation: const WidgetStatePropertyAll(0),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:  8.0),
                            child: Text(
                              i10n.register,
                              style: textTheme.titleLarge!.copyWith(
                                color: colorScheme.onSurface
                              ),
                            ),
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 3,
                            ),
                          ),
                          Text('   ${i10n.or}   ', style: textTheme.bodyLarge,),
                          const Expanded(
                            child: Divider(
                              thickness: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ElevatedButton(
                          onPressed: ()=> context.push(routeLogUserPage), 
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(colorScheme.tertiaryContainer),
                            elevation: const WidgetStatePropertyAll(3),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(width: 1)
                              )
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: 40,
                                ),
                                const SizedBox(width: 10,),
                                Text(
                                  i10n.connectWithoutAccount,
                                  style: textTheme.labelLarge!.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                    fontSize: 20
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                    const Spacer(flex: 3,),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

}

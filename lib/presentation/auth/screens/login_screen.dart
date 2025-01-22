import 'dart:async';

import 'package:couples_client_app/presentation/auth/widgets/intro_page.dart';
import 'package:couples_client_app/shared/helpers/func_helpers.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
    return Scaffold(
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
      backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:  25, right: 25, left: 25),
                  child: PageView(
                    controller: pageController,
                    children: [
                      IntroPage(
                        lottieURL: getAsset('animations/intro/page1.json'),
                        tittle: AppLocalizations.of(context)!.introTitlePage1,
                        text: AppLocalizations.of(context)!.descIntroPage1,
                        righOrientation: false,
                      ),
                      IntroPage(
                        lottieURL: getAsset("animations/intro/page2.json"),
                        tittle: AppLocalizations.of(context)!.introTitlePage2,
                        text: AppLocalizations.of(context)!.descIntroPage2,
                        righOrientation: true,
                      ),
                      IntroPage(
                        lottieURL: getAsset("animations/intro/page3.json"),
                        tittle: AppLocalizations.of(context)!.introTitlePage3,
                        text: AppLocalizations.of(context)!.descIntroPage3,
                        righOrientation: false,
                      ),
                      IntroPage(
                        lottieURL: getAsset("animations/intro/page4.json"),
                        tittle: AppLocalizations.of(context)!.introTitlePage4,
                        text: AppLocalizations.of(context)!.descIntroPage4,
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
                        dotWidth: 20,
                        dotHeight: 20,
                        spacing: 15,
                        dotColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                        activeDotColor: Theme.of(context).colorScheme.primary,
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
          const SizedBox(height: 10,),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  const Spacer(flex: 1,),
                  Text(
                    AppLocalizations.of(context)!.loginWith,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2,),
                      _getLoginButton('images/icons/mail.png'),
                      const Spacer(),
                      _getLoginButton('images/icons/google.png'),
                      const Spacer(flex: 2,),
                    ],
                  ),
                  const Spacer(flex: 1,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ElevatedButton(
                      onPressed: (){}, 
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiaryContainer),
                        elevation: const WidgetStatePropertyAll(3)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.heart),
                            const SizedBox(width: 10,),
                            Text(
                              AppLocalizations.of(context)!.connectWithoutAccount,
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onTertiaryContainer,
                                fontSize: 20
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Divider(
                      thickness: 3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.youreNewQuestion,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 5,),
                      TextButton(
                        onPressed: (){}, 
                        child: Text( 
                          AppLocalizations.of(context)!.registerHere,
                           style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.deepPurple
                           ),
                        )
                      )
                    ],
                  ),
                   const Spacer(),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }



  Widget _getLoginButton(String asset){
    return ElevatedButton(
      onPressed: (){}, 
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
        elevation: const WidgetStatePropertyAll(3)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Image.asset(
          getAsset(asset),
          height: 50,
        ),
      )
    );
  }
}

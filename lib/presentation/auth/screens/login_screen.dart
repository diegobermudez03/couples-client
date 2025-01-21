import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class LoginScreen extends StatefulWidget {
  static final List<Widget> pages = [
    Container(
      child: const Center(child: Text("Page 1")),
    ),
    Container(
      child: const Center(child: Text("Page 2")),
    ),
    Container(
      child: const Center(child: Text("Page 3")),
    ),
    Container(
      child: const Center(child: Text("Page 4")),
    ),
  ];

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/general/app_title.png',
            fit: BoxFit.fitHeight,
            height: 50,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: LoginScreen.pages,
                  onPageChanged: (value) => setState(() {
                    currentPage = value;
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSmoothIndicator(    
                      activeIndex: currentPage,    
                      count: 4,    
                      effect: WormEffect(
                        dotWidth: 20,
                        dotHeight: 20,
                        spacing: 15,
                        dotColor: Theme.of(context).colorScheme.primaryFixedDim,
                        activeDotColor: Theme.of(context).colorScheme.onSurface,
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
            flex: 1,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.loginWith,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2,),
                    ElevatedButton(
                      onPressed: (){}, 
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/icons/mail.png',
                          height: 50,
                        ),
                      )
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: (){}, 
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/icons/google.png',
                          height: 50,
                        ),
                      )
                    ),
                    const Spacer(flex: 2,),
                  ],
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Divider(
                    thickness: 3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.youreNewQuestion,
                    ),
                    TextButton(
                      onPressed: (){}, 
                      child: Text( AppLocalizations.of(context)!.registerHere)
                    )
                  ],
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}

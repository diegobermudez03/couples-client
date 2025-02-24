import 'package:couples_client_app/core/dependency_injection/dep_in.dart';
import 'package:couples_client_app/core/navigation/router.dart';
import 'package:couples_client_app/l10n/l10n.dart';
import 'package:couples_client_app/services/localization_services/local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  final codes = await Future.wait([
    GetIt.instance.get<LocalizationService>().getCountry(),
    GetIt.instance.get<LocalizationService>().getLanguage()
  ]);
  runApp(MyApp(
    langCode: codes[1],
    countryCode: codes[0],
  ));
}

class MyApp extends StatelessWidget {
  final String langCode;
  final String countryCode;
  const MyApp({super.key, required this.langCode, required this.countryCode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Couples app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 112, 214, 255),
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant
        ),
        textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Locale(langCode),
      routerConfig: router,
    );
  }
}


import 'package:couples_client_app/services/localization_services/local_service.dart';
import 'package:couples_client_app/services/preferences/preferences_service.dart';
import 'package:get_it/get_it.dart';

final depIn = GetIt.instance; 

Future<void> initDependencies() async{
  // services
  final prefServices = await PreferencesServiceImpl.getPreferences();
  depIn.registerSingleton<PreferencesService>(prefServices);
  depIn.registerSingleton<LocalizationService>(LocalizationServiceImpl(prefServices));

}
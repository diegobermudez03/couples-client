
import 'package:universal_io/io.dart';
import 'package:couples_client_app/services/preferences/preferences_service.dart';

abstract class LocalizationService{
  Future<String> getCountry();
  Future<String> getLanguage();
}


class LocalizationServiceImpl implements LocalizationService{

  final PreferencesService prefService;
  LocalizationServiceImpl(this.prefService);

  @override
  Future<String> getCountry() async{
    var country = await prefService.getStringVal('country');
    if(country != null){
      return country;
    }
    String deviceLocale = Platform.localeName; 
    country = deviceLocale.length > 3 ? deviceLocale.substring(3, 5) : "US";
    prefService.setValue('country', country);
    return country;
  }

  @override 
  Future<String> getLanguage() async{
   var language = await prefService.getStringVal('language');
    if(language != null){
      return language;
    }
    String deviceLocale = Platform.localeName;
    String languageCode = deviceLocale.substring(0, 2); 
    prefService.setValue('language', languageCode);
    return languageCode;
  }
}
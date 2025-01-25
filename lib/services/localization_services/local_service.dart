
import 'package:ip_country_lookup/ip_country_lookup.dart';
import 'package:ip_country_lookup/models/ip_country_data_model.dart';
import 'package:universal_io/io.dart';
import 'package:couples_client_app/services/preferences/preferences_service.dart';

abstract class LocalizationService{
  Future<String> getCountry();
  Future<String> getLanguage();
}


class LocalizationServiceImpl implements LocalizationService{

  final PreferencesService prefService;
  String? cacheCountryCode;
  String? cacheLanguageCode;
  LocalizationServiceImpl(this.prefService);

  @override
  Future<String> getCountry() async{
    if(cacheCountryCode != null) return cacheCountryCode!;
    var country = await prefService.getStringVal('country');
    if(country != null){
      cacheCountryCode = country;
      return country;
    }
    IpCountryData countryData = await IpCountryLookup().getIpLocationData();
    country = countryData.country_code ?? 'US';
    prefService.setValue('country', country);
    cacheCountryCode = country;
    return country;
  }

  @override 
  Future<String> getLanguage() async{
    if(cacheLanguageCode != null) return cacheLanguageCode!;
    var language = await prefService.getStringVal('language');
    if(language != null){
      cacheLanguageCode = language;
      return language;
    }
    String deviceLocale = Platform.localeName;
    String languageCode = deviceLocale.substring(0, 2); 
    prefService.setValue('language', languageCode);
    cacheCountryCode = language;
    return languageCode;
  }
}
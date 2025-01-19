import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesService {
  void setValue<T>(String key,T val);
  Future<String?> getStringVal(String key);
}


class PreferencesServiceImpl implements PreferencesService{

  final SharedPreferences prefs;
  PreferencesServiceImpl(this.prefs);

  static Future<PreferencesServiceImpl> getPreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return PreferencesServiceImpl(prefs);
  }

  @override
  void setValue<T>(String key, T val) async{
    switch(val){
      case int _ : await  prefs.setInt(key, val); break;
      case double _ : await  prefs.setDouble(key, val); break;
      case String _ : await  prefs.setString(key, val); break;
      case bool _ : await  prefs.setBool(key, val); break;
      default: {}break;
    }
  }

  @override
  Future<String?> getStringVal(String key) async{
   return prefs.getString(key);
  }

}
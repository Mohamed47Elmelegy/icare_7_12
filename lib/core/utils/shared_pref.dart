import 'package:icare/core/strings/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static final SharedPref preferences = SharedPref._internal();

  static late SharedPreferences sharedPreferences;

  factory SharedPref() {
    return preferences;
  }

  SharedPref._internal();

  ///Below method is to initialize the SharedPreference instance.
  Future instantiatePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(!sharedPreferences.containsKey(Constants.userLang))sharedPreferences.setString(Constants.userLang, "ar");
    if(!sharedPreferences.containsKey(Constants.userTheme))sharedPreferences.setString(Constants.userTheme, "light");
  }

  ///Below method is to return the SharedPreference instance.
  SharedPreferences getPreferenceInstance() {
    return sharedPreferences;
  }

  ///Below method is to set the string value in the SharedPreferences.
  setPreferencesString(String key, String stringValue) {
    sharedPreferences.setString(key, stringValue);
  }

  ///Below method is to get the string value from the SharedPreferences.
  String getPreferenceString(String key) {
    return sharedPreferences.getString(key) ?? "";
  }

  ///Below method is to set the boolean value in the SharedPreferences.
  setPreferencesBoolean(String key, bool booleanValue) {
    sharedPreferences.setBool(key, booleanValue);
  }

  ///Below method is to get the boolean value from the SharedPreferences.
  bool getPreferenceBoolean(String key) {
    return sharedPreferences.getBool(key) ?? false;
  }

  ///Below method is to set the double value in the SharedPreferences.
  setPreferenceDouble(String key, double doubleValue) {
    sharedPreferences.setDouble(key, doubleValue);
  }

  ///Below method is to set the double value from the SharedPreferences.
  double getPreferenceDouble(String key) {
    return sharedPreferences.getDouble(key) ?? 0.0;
  }

  ///Below method is to set the int value in the SharedPreferences.
  setPreferenceInt(String key, int intValue) {
    sharedPreferences.setInt(key, intValue);
  }

  ///Below method is to get the int value from the SharedPreferences.
  int getPreferenceInt(String key) {
    return sharedPreferences.getInt(key) ?? 0;
  }

  ///Below method is to remove the received preference.
  removePreference(String key) {
    sharedPreferences.remove(key);
  }

  ///Below method is to check the availability of the received preference .
  bool containPreference(String key) {
    if (sharedPreferences.get(key) == null) {
      return false;
    } else {
      return true;
    }
  }

  ///Below method is to clear the SharedPreference.
  clearPreferences() async {
    await sharedPreferences.clear();
    if(!sharedPreferences.containsKey(Constants.userLang))sharedPreferences.setString(Constants.userLang, "ar");
  }
}

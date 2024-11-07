import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService();
  SharedPreferencesService get instance => _instance;

  late final SharedPreferences sharedPreferences;

  Future init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}

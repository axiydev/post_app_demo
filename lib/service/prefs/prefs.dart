import 'package:post_app_demo/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefsRepository {
  Future<bool> saveData({required String? key, required String? data});
  Future<String?> getData({required String? key});
  Future<bool> deleteData({required String? key});
}

class Prefs extends SharedPrefsRepository {
  Prefs._private();
  static final _instance = Prefs._private();
  factory Prefs() {
    return _instance;
  }
  @override
  Future<bool> deleteData({required String? key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(key!);
    } catch (e) {
      Log.log(e);
      rethrow;
    }
  }

  @override
  Future<String?> getData({required String? key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.get(key!) as String?;
    } catch (e) {
      Log.log(e);
      rethrow;
    }
  }

  @override
  Future<bool> saveData({required String? key, required String? data}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setString(key!, data!);
    } catch (e) {
      Log.log(e);
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../models/cacheConfig.dart';
import 'dart:convert';
import '../service/cache.dart';
import '../service/request.dart';

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  static NetCache netCache = NetCache();
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;
    Request.init();
  }

  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}

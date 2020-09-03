import 'dart:collection';

import 'package:dio/dio.dart';
import '../common/global.dart';

class CacheObject {
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();
  @override
  Future onRequest(RequestOptions options) async {
    if (!Global.profile.cache.enable) return options;
    bool refresh = options.extra['refresh'] == true;
    if (refresh) {
      if (options.extra['list'] == true) {
        cache.removeWhere((key, v) => key.contains(options.path));
      } else {
        delete(options.uri.toString());
      }
    }

    if (options.extra['noCache'] != true &&
        options.method.toLowerCase() == "get") {
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            Global.profile.cache.maxAge) {
          return cache[key].response;
        } else {
          cache.remove(key);
        }
      }
    }
    // TODO: implement onRequest
    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    // TODO: implement onError
    print(err);
  }

  @override
  Future onResponse(Response response) async {
    if (Global.profile.cache.enable) {
      _saveCache(response);
    }
  }

  _saveCache(Response object) {
    RequestOptions options = object.request;
    if (options.extra['noCache'] != true &&
        options.method.toLowerCase() == "get") {
      if (cache.length == Global.profile.cache.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}

import 'package:dio/dio.dart';
import './global.dart';

class CacheObject {
  Response response;
  // 缓存创建时间
  int timeStamp;

  CacheObject(this.response) : timeStamp = DateTime.now().microsecondsSinceEpoch;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = <String, CacheObject>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!(Global.profile.cache?.enable ?? false)) {
      return handler.next(options);
    }
    // refresh标记是否是"下拉刷新"
    bool refresh = options.extra["refresh"] == true;
    //如果是下拉刷新，先删除相关缓存
    if (refresh) {
      if (options.extra["list"] == true) {
        //若是列表，则只要url中包含当前path的缓存全部删除（简单实现，并不精准）
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
        delete(options.uri.toString());
      }
      return handler.next(options);
    }

    if (options.extra["noCache"] != true && options.method.toLowerCase() == "get") {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        //若缓存未过期，则返回缓存内容
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 < Global.profile.cache!.maxAge) {
          return handler.resolve(ob.response);
        } else {
          //若已过期则删除缓存，继续向服务器请求
          cache.remove(key);
        }
      }
    }
    handler.next(options);
  }

  void delete(String key) {
    cache.remove(key);
  }
}

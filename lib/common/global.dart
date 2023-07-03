import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
// 主题色数组
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static late SharedPreferences _prefs;
  static Profile profile = Profile();
  // 网络缓存对象
  // static
  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;
  // 是否为 release 版本
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  // 初始化全局信息，会在 APP 启东时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    } else {
      // 默认主题为索引为 0，代表蓝色
      profile = Profile()..theme = 0;
    }
    // 如果没有缓存策略，设置默认缓存策略
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;
    // 初始化网络请求相关配置
    // TODO: 网络初始化
    // Git.init();
  }

  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
}

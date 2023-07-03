import 'dart:convert';
import 'user.dart';
import 'cache_config.dart';

class Profile {
  User? user;
  String? token;
  int? theme;
  CacheConfig? cache;
  String? lastLogin;
  String? locale;

  Profile({
    this.user,
    this.token,
    this.theme,
    this.cache,
    this.lastLogin,
    this.locale,
  });

  factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        user: User.fromJson(json["user"]),
        token: json["token"],
        theme: json["theme"],
        cache: CacheConfig.fromJson(json["cache"]),
        lastLogin: json["lastLogin"],
        locale: json["locale"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "theme": theme,
        "cache": cache?.toJson(),
        "lastLogin": lastLogin,
        "locale": locale,
      };
}

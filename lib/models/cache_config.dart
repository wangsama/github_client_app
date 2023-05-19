// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class CacheConfig {
    bool enable;
    int maxAge;
    int maxCount;

    CacheConfig({
        required this.enable,
        required this.maxAge,
        required this.maxCount,
    });

    factory CacheConfig.fromRawJson(String str) => CacheConfig.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CacheConfig.fromJson(Map<String, dynamic> json) => CacheConfig(
        enable: json["enable"],
        maxAge: json["maxAge"],
        maxCount: json["maxCount"],
    );

    Map<String, dynamic> toJson() => {
        "enable": enable,
        "maxAge": maxAge,
        "maxCount": maxCount,
    };
}

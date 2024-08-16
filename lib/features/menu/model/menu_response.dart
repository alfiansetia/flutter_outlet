import 'dart:convert';

import 'package:flutter_outlet/features/menu/model/menu.dart';
import 'package:flutter_outlet/models/links.dart';
import 'package:flutter_outlet/models/meta.dart';

class MenuResponse {
  MenuResponse({
    required this.data,
    this.meta,
    this.links,
  });

  factory MenuResponse.fromJson(String str) =>
      MenuResponse.fromMap(json.decode(str));

  factory MenuResponse.fromMap(Map<String, dynamic> json) => MenuResponse(
        data: List<Menu>.from(
          json['data'].map((x) => Menu.fromMap(x)),
        ),
        meta: json['meta'] == null ? null : Meta.fromMap(json['meta']),
        links: json['links'] == null ? null : Links.fromMap(json['links']),
      );

  factory MenuResponse.initial() => MenuResponse(
        data: [],
        meta: null,
        links: null,
      );

  List<Menu> data;
  Meta? meta;
  Links? links;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta?.toMap(),
        "links": links?.toMap(),
      };
}

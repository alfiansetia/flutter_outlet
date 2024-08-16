import 'dart:convert';

import 'package:flutter_outlet/models/links.dart';
import 'package:flutter_outlet/models/meta.dart';
import 'package:flutter_outlet/features/branch_menu/models/branch_menu.dart';

class BranchMenuResponse {
  BranchMenuResponse({
    required this.data,
    this.meta,
    this.links,
  });

  factory BranchMenuResponse.fromJson(String str) =>
      BranchMenuResponse.fromMap(json.decode(str));

  factory BranchMenuResponse.fromMap(Map<String, dynamic> json) =>
      BranchMenuResponse(
        data: List<BranchMenu>.from(
          json['data'].map((x) => BranchMenu.fromMap(x)),
        ),
        meta: json['meta'] == null ? null : Meta.fromMap(json['meta']),
        links: json['links'] == null ? null : Links.fromMap(json['links']),
      );

  factory BranchMenuResponse.initial() => BranchMenuResponse(
        data: [],
        meta: null,
        links: null,
      );

  List<BranchMenu> data;
  Meta? meta;
  Links? links;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta?.toMap(),
        "links": links?.toMap(),
      };
}

import 'dart:convert';

import 'package:flutter_outlet/models/links.dart';
import 'package:flutter_outlet/models/meta.dart';
import 'package:flutter_outlet/features/order/models/order.dart';

class OrderResponse {
  OrderResponse({
    required this.data,
    this.meta,
    this.links,
  });

  factory OrderResponse.fromJson(String str) =>
      OrderResponse.fromMap(json.decode(str));

  factory OrderResponse.fromMap(Map<String, dynamic> json) => OrderResponse(
        data: List<Order>.from(
          json['data'].map((x) => Order.fromMap(x)),
        ),
        meta: json['meta'] == null ? null : Meta.fromMap(json['meta']),
        links: json['links'] == null ? null : Links.fromMap(json['links']),
      );

  factory OrderResponse.initial() => OrderResponse(
        data: [],
        meta: null,
        links: null,
      );

  List<Order> data;
  Meta? meta;
  Links? links;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta?.toMap(),
        "links": links?.toMap(),
      };
}

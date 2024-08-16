import 'dart:convert';

import 'package:flutter_outlet/features/branch_menu/models/branch_menu.dart';

class OrderItem {
  OrderItem({
    required this.id,
    required this.orderId,
    this.branchMenuId,
    required this.price,
    required this.discount,
    required this.qty,
    this.branchMenu,
    required this.subtotal,
    required this.totalDiscount,
  });

  factory OrderItem.fromJson(String str) => OrderItem.fromMap(json.decode(str));

  factory OrderItem.fromMap(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        orderId: json["order_id"],
        branchMenuId: json["branch_menu_id"],
        price: json["price"],
        discount: json["discount"],
        qty: json["qty"],
        branchMenu: json["branch_menu"] == null
            ? null
            : BranchMenu.fromMap(json['branch_menu']),
        subtotal: json["subtotal"],
        totalDiscount: json["total_discount"],
      );

  factory OrderItem.initial() => OrderItem(
        id: 1,
        orderId: 1,
        branchMenuId: null,
        price: 0,
        discount: 0,
        qty: 0,
        branchMenu: null,
        subtotal: 0,
        totalDiscount: 0,
      );

  int id;
  int orderId;
  int? branchMenuId;
  int price;
  int discount;
  int qty;
  BranchMenu? branchMenu;
  int subtotal;
  int totalDiscount;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "order_id": orderId,
        "branch_menu_id": branchMenuId,
        "price": price,
        "discount": discount,
        "qty": qty,
        "branch_menu": branchMenu?.toMap(),
        "subtotal": subtotal,
        "total_discount": totalDiscount,
      };
}

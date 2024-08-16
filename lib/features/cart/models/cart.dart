import 'dart:convert';

import 'package:flutter_outlet/features/branch_menu/models/branch_menu.dart';

class Cart {
  Cart({
    required this.id,
    required this.userId,
    required this.branchMenuId,
    required this.qty,
    this.branchMenu,
  });

  factory Cart.fromJson(String str) => Cart.fromMap(json.decode(str));

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
        id: json["id"],
        userId: json["user_id"],
        branchMenuId: json["branch_menu_id"],
        qty: json["qty"],
        branchMenu: json["branch_menu"] == null
            ? null
            : BranchMenu.fromMap(json['branch_menu']),
      );

  factory Cart.initial() => Cart(
        id: 0,
        userId: 0,
        branchMenuId: 0,
        qty: 0,
        branchMenu: null,
      );

  int id;
  int userId;
  int branchMenuId;
  int qty;
  BranchMenu? branchMenu;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "branch_menu_id": branchMenuId,
        "qty": qty,
        "branch_menu": branchMenu?.toMap(),
      };
  Cart copyWith({
    int? id,
    int? qty,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId,
      branchMenuId: branchMenuId,
      qty: qty ?? this.qty,
      branchMenu: branchMenu,
    );
  }
}

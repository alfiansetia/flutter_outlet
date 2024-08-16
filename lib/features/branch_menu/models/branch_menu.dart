import 'dart:convert';

import 'package:flutter_outlet/features/branch/models/branch.dart';
import 'package:flutter_outlet/features/menu/model/menu.dart';

class BranchMenu {
  BranchMenu({
    required this.id,
    required this.branchId,
    required this.menuId,
    required this.price,
    required this.discount,
    required this.isFavorite,
    required this.isAvailable,
    required this.menu,
    required this.branch,
    this.incart,
    required this.discountPrice,
  });

  factory BranchMenu.fromJson(String str) =>
      BranchMenu.fromMap(json.decode(str));

  factory BranchMenu.fromMap(Map<String, dynamic> json) => BranchMenu(
        id: json["id"],
        branchId: json["branch_id"],
        menuId: json["menu_id"],
        price: json["price"],
        discount: json["discount"],
        isFavorite: json["is_favorite"],
        isAvailable: json["is_available"],
        menu: json["menu"] == null ? null : Menu.fromMap(json['menu']),
        branch: json["branch"] == null ? null : Branch.fromMap(json['branch']),
        incart: json["incart"] ?? 0,
        discountPrice: json["discount_price"] ?? 0,
      );

  factory BranchMenu.initial() => BranchMenu(
        id: 1,
        branchId: 1,
        menuId: 1,
        price: 0,
        discount: 0,
        isFavorite: false,
        isAvailable: false,
        menu: null,
        branch: null,
        incart: 0,
        discountPrice: 0,
      );

  int id;
  int branchId;
  int menuId;
  int price;
  int discount;
  bool isFavorite;
  bool isAvailable;
  Menu? menu;
  Branch? branch;
  int? incart;
  int discountPrice;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "branch_id": branchId,
        "menu_id": menuId,
        "price": price,
        "discount": discount,
        "is_favorite": isFavorite,
        "is_available": isAvailable,
        "menu": menu?.toMap(),
        "branch": branch?.toMap(),
        "incart": incart ?? 0,
        "discount_price": discountPrice,
      };

  BranchMenu copyWith({
    int? id,
    int? incart,
  }) {
    return BranchMenu(
      id: id ?? this.id,
      branchId: branchId,
      menuId: menuId,
      price: price,
      discount: discount,
      isFavorite: isFavorite,
      isAvailable: isAvailable,
      menu: menu,
      branch: branch,
      incart: incart ?? this.incart,
      discountPrice: discountPrice,
    );
  }
}

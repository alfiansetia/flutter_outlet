import 'dart:convert';

import 'package:flutter_outlet/models/user.dart';
import 'package:flutter_outlet/features/order_item/models/order_item.dart';

class Order {
  Order({
    required this.id,
    required this.name,
    this.userId,
    required this.branchId,
    required this.date,
    required this.number,
    required this.payment,
    this.trxId,
    required this.status,
    this.cancleReason,
    required this.ppn,
    required this.total,
    required this.bill,
    required this.returN,
    required this.orderItem,
    this.user,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["id"],
        name: json["name"] ?? '-',
        userId: json["user_id"],
        branchId: json["branch_id"],
        date: json["date"],
        number: json["number"],
        payment: json["payment"],
        trxId: json["trx_id"],
        status: json["status"],
        cancleReason: json["cancle_reason"],
        ppn: json["ppn"],
        total: json["total"],
        bill: json["bill"],
        returN: json["return"],
        orderItem: json["items"] == null
            ? []
            : List<OrderItem>.from(
                json["items"].map(
                  (x) => OrderItem.fromMap(x),
                ),
              ),
        user: json['user'] == null ? null : User.fromMap(json['user']),
      );

  factory Order.initial() => Order(
        id: 0,
        name: '-',
        branchId: 0,
        date: '',
        number: '',
        payment: '',
        status: '',
        ppn: 0,
        total: 0,
        bill: 0,
        returN: 0,
        orderItem: [],
      );

  int bill;
  int branchId;
  String? cancleReason;
  String date;
  int id;
  String name;
  String number;
  List<OrderItem> orderItem;
  String payment;
  int ppn;
  int returN;
  String status;
  int total;
  String? trxId;
  User? user;
  int? userId;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "branch_id": branchId,
        "date": date,
        "number": number,
        "payment": payment,
        "trx_id": trxId,
        "status": status,
        "cancle_reason": cancleReason,
        "ppn": ppn,
        "total": total,
        "bill": bill,
        "return": returN,
        "items": List<dynamic>.from(
          orderItem.map(
            (x) => x.toMap(),
          ),
        ),
        'user': user?.toMap(),
      };
}

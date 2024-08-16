import 'dart:convert';

class Branch {
  Branch({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.logo,
  });

  factory Branch.fromJson(String str) => Branch.fromMap(json.decode(str));

  factory Branch.fromMap(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        logo: json["logo"],
      );

  factory Branch.initial() => Branch(
        id: 1,
        name: '',
        phone: 'other',
        address: '',
        logo: '',
      );

  int id;
  String name;
  String phone;
  String address;
  String logo;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "logo": logo,
      };
}

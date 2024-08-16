import 'dart:convert';

class Menu {
  Menu({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    this.description,
  });

  factory Menu.fromJson(String str) => Menu.fromMap(json.decode(str));

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        image: json["image"],
        description: json["description"],
      );

  factory Menu.initial() => Menu(
        id: 1,
        name: '',
        category: 'other',
        image: '',
        description: null,
      );

  int id;
  String name;
  String category;
  String image;
  String? description;

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
        "image": image,
        "description": description,
      };
}

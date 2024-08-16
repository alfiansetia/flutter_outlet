import 'dart:convert';

class MetaLink {
  String? url;
  String? label;
  bool? active;

  MetaLink({
    this.url,
    this.label,
    this.active,
  });

  factory MetaLink.fromJson(String str) => MetaLink.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MetaLink.fromMap(Map<String, dynamic> json) => MetaLink(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

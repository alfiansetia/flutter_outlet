import 'dart:convert';

class Printer {
  final String name;
  final String mac;

  Printer({
    required this.name,
    required this.mac,
  });

  @override
  String toString() => 'Printer(name: $name, mac: $mac)';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'mac': mac});
  
    return result;
  }

  factory Printer.fromMap(Map<String, dynamic> map) {
    return Printer(
      name: map['name'] ?? '',
      mac: map['mac'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Printer.fromJson(String source) =>
      Printer.fromMap(json.decode(source));

  Printer copyWith({
    String? name,
    String? mac,
    bool? isDefault,
  }) {
    return Printer(
      name: name ?? this.name,
      mac: mac ?? this.mac,
    );
  }
}

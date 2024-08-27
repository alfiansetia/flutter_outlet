import 'dart:convert';

enum PaperSetting {
  mm58,
  mm80,
  mm72,
}

class Setting {
  Setting({
    required this.defaultName,
    required this.paper,
    required this.defaultMac,
  });

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source));

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      paper: PaperSetting.values.byName(map['paper']),
      defaultMac: map['defaultMac'] ?? '00:00:00:00:00:00',
      defaultName: map['defaultName'] ?? '-',
    );
  }

  factory Setting.initial() => Setting(
        paper: PaperSetting.mm58,
        defaultMac: "00:00:00:00:00:00",
        defaultName: "-",
      );

  final String defaultName;
  final String defaultMac;
  final PaperSetting paper;

  @override
  String toString() =>
      'Setting(paper: $paper, defaultMac: $defaultMac, defaultName: $defaultName)';

  Setting copyWith({
    PaperSetting? paper,
    String? defaultMac,
    String? defaultName,
  }) {
    return Setting(
      paper: paper ?? this.paper,
      defaultMac: defaultMac ?? this.defaultMac,
      defaultName: defaultName ?? this.defaultName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'paper': paper.name});
    result.addAll({'defaultMac': defaultMac});
    result.addAll({'defaultName': defaultName});

    return result;
  }

  String toJson() => json.encode(toMap());
}

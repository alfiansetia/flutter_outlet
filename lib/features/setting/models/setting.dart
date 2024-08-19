import 'dart:convert';

enum PaperSetting {
  mm58,
  mm80,
}

class Setting {
  Setting({
    required this.paper,
    required this.defaultMac,
  });

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source));

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
      paper: PaperSetting.values.byName(map['paper']),
      defaultMac: map['defaultMac'] ?? '',
    );
  }

  factory Setting.initial() => Setting(
        paper: PaperSetting.mm58,
        defaultMac: "00:00:00:00:00:00",
      );

  final String defaultMac;
  final PaperSetting paper;

  @override
  String toString() => 'Setting(paper: $paper, defaultMac: $defaultMac)';

  Setting copyWith({
    PaperSetting? paper,
    String? defaultMac,
  }) {
    return Setting(
      paper: paper ?? this.paper,
      defaultMac: defaultMac ?? this.defaultMac,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'paper': paper.name});
    result.addAll({'defaultMac': defaultMac});

    return result;
  }

  String toJson() => json.encode(toMap());
}

class DhikrItem {
  String text;
  int target;
  int current;
  DateTime? lastUpdated;

  DhikrItem({
    required this.text,
    required this.target,
    this.current = 0,
    this.lastUpdated,
  });

  factory DhikrItem.fromJson(Map<String, dynamic> json) {
    return DhikrItem(
      text: json['text'] as String,
      target: json['target'] as int,
      current: json['current'] as int,
      lastUpdated: json['lastUpdated'] != null 
        ? DateTime.parse(json['lastUpdated'] as String)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'target': target,
      'current': current,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
} 
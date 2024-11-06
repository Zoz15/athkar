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

  Map<String, dynamic> toJson() => {
    'text': text,
    'target': target,
    'current': current,
    'lastUpdated': lastUpdated?.toIso8601String(),
  };

  factory DhikrItem.fromJson(Map<String, dynamic> json) => DhikrItem(
    text: json['text'],
    target: json['target'],
    current: json['current'] ?? 0,
    lastUpdated: json['lastUpdated'] != null 
      ? DateTime.parse(json['lastUpdated'])
      : null,
  );
} 
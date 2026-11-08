class Entry {
  Entry({
    required this.type,
    required this.title,
    required this.details,
    required this.date,
  });
  final String type, title, details, date;
  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'details': details,
    'date': date,
  };
  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    type: json['type'],
    title: json['title'],
    details: json['details'],
    date: json['date'],
  );
}

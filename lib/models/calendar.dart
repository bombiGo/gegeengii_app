class Calendar {
  final int id;
  final String name;
  final int year;
  final int month;
  final int day;
  final String description;

  Calendar({
    this.id,
    this.name,
    this.year,
    this.month,
    this.day,
    this.description,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      description: json['description'],
    );
  }
}

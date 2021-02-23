class UserCalendar {
  final int id;
  // final int user_id;
  final String full_day;
  final String drink_count;
  final String walk_count;
  final String mood;
  final String weight;
  final String sympton;
  final String note;

  UserCalendar({
    this.id,
    // this.user_id,
    this.full_day,
    this.drink_count,
    this.walk_count,
    this.mood,
    this.weight,
    this.sympton,
    this.note,
  });

  factory UserCalendar.fromJson(Map<String, dynamic> json) {
    return UserCalendar(
      id: json['id'],
      // user_id: json['user_id'],
      full_day: json['full_day'],
      drink_count: json['drink_count'],
      walk_count: json['walk_count'],
      mood: json['mood'],
      weight: json['weight'],
      sympton: json['sympton'],
      note: json['note'],
    );
  }
}

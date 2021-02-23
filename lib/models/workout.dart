class Workout {
  final int id;
  final String title;
  final String image;
  final String content;
  final String subtitle;

  Workout({
    this.id,
    this.title,
    this.image,
    this.content,
    this.subtitle,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      content: json['content'],
      subtitle: json['subtitle'],
    );
  }
}

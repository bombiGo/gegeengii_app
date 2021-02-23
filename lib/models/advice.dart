class Advice {
  final int id;
  final String title;
  final String image;
  final String content;
  final String subtitle;

  Advice({
    this.id,
    this.title,
    this.image,
    this.content,
    this.subtitle,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      content: json['content'],
      subtitle: json['subtitle'],
    );
  }
}

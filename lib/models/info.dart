class Info {
  final int id;
  final String title;
  final String image;
  final String content;
  final String subtitle;

  Info({
    this.id,
    this.title,
    this.image,
    this.content,
    this.subtitle,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      content: json['content'],
      subtitle: json['subtitle'],
    );
  }
}

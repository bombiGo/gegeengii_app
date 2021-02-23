class RecipeNew {
  final int id;
  final String title;
  final String image;
  final String content;
  final String subtitle;

  RecipeNew({
    this.id,
    this.title,
    this.image,
    this.content,
    this.subtitle,
  });

  factory RecipeNew.fromJson(Map<String, dynamic> json) {
    return RecipeNew(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      content: json['content'],
      subtitle: json['subtitle'],
    );
  }
}

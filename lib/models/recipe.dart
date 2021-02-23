class Recipe {
  final int id;
  final String title;
  final String image;
  final String content;

  Recipe({
    this.id,
    this.title,
    this.image,
    this.content,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      content: json['content'],
    );
  }
}

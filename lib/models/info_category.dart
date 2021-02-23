class InfoCategory {
  final int id;
  final String name;
  final String image;
  final List infos;

  InfoCategory({
    this.id,
    this.name,
    this.image,
    this.infos,
  });

  factory InfoCategory.fromJson(Map<String, dynamic> json) {
    return InfoCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      infos: json['infos'],
    );
  }
}

class RecipeCategory {
  final int id;
  final String name;
  final String image;
  final List recipes;

  RecipeCategory({
    this.id,
    this.name,
    this.image,
    this.recipes,
  });

  factory RecipeCategory.fromJson(Map<String, dynamic> json) {
    return RecipeCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      recipes: json['recipes'],
    );
  }
}

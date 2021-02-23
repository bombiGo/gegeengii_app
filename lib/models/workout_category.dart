class WorkoutCategory {
  final int id;
  final String name;
  final String image;
  final List workouts;

  WorkoutCategory({
    this.id,
    this.name,
    this.image,
    this.workouts,
  });

  factory WorkoutCategory.fromJson(Map<String, dynamic> json) {
    return WorkoutCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      workouts: json['workouts'],
    );
  }
}

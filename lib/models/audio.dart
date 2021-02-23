class Audio {
  final int id;
  final String name;
  final String url;
  final int duration;

  Audio({
    this.id,
    this.name,
    this.url,
    this.duration,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      duration: json['duration'],
    );
  }
}

class Course {
  final int id;
  final String title;
  final String content;
  final String image;
  final String notifyMsg;
  final String price;
  final List days;
  final List comments;

  Course({
    this.id,
    this.title,
    this.content,
    this.image,
    this.notifyMsg,
    this.price,
    this.days,
    this.comments,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      notifyMsg: json['notify_msg'],
      price: json['price'],
      days: json['days'],
      comments: json['comments'],
    );
  }
}

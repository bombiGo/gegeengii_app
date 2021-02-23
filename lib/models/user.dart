class User {
  int id;
  String name;
  String email;
  String token;
  String lastname;
  String phone;
  String birthday;
  String gender;
  String image;

  User({
    this.id,
    this.name,
    this.email,
    this.token,
    this.lastname,
    this.phone,
    this.birthday,
    this.gender,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      lastname: json['lastname'],
      phone: json['phone'],
      birthday: json['birthday'],
      gender: json['gender'],
      image: json['image'],
    );
  }
}

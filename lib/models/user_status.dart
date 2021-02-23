class UserStatus {
  final String type;
  final String date;
  final String value;

  UserStatus({
    this.type,
    this.date,
    this.value,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      type: json['type'],
      date: json['date'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toMap(UserStatus userStatus) => {
        'type': userStatus.type,
        'date': userStatus.date,
        'value': userStatus.value,
      };
}

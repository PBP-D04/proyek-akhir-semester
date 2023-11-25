class User {
  final String username;
  final String fullname;
  final String country;
  final String city;
  final int age;
  final String phoneNumber;
  final String? profilePicture;
  final int id;

  User({
    required this.id,
    required this.username,
    required this.fullname,
    required this.country,
    required this.city,
    required this.age,
    required this.phoneNumber,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      country: json['country'],
      city: json['city'],
      age: json['age'],
      phoneNumber: json['phone_number'],
      profilePicture: json['profile_picture'],
    );
  }
}
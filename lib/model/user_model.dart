//User Model
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String birthday;
  final String state;
  final String country;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.birthday,
      required this.country,
      required this.state});

  factory UserModel.fromMap(Map data) {
    return UserModel(
        uid: data['uid'],
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        birthday: data['birthday'] ?? '',
        country: data['country'] ?? '',
        state: data['state'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "birthday": birthday,
        "country": country,
        "state": state
      };
}

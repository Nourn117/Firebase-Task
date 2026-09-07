class UserModel {
  final String uid;
  final String email;
  final String nickname;
  final String sportPreference;

  UserModel({
    required this.uid,
    required this.email,
    required this.nickname,
    required this.sportPreference,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'sportPreference': sportPreference,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nickname: map['nickname'] ?? '',
      sportPreference: map['sportPreference'] ?? '',
    );
  }
}

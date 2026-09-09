import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap())
        .timeout(const Duration(seconds: 10));
  }

  Future<UserModel> getUser(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();

    if (!document.exists || document.data() == null) {
      throw Exception('User data not found.');
    }

    return UserModel.fromMap(document.data()!);
  }
}
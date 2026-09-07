import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    print('FIRESTORE: starting save...');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toMap())
          .timeout(
        const Duration(seconds: 10),
      );

      print('FIRESTORE: save successful!');
    } catch (e) {
      print('FIRESTORE ERROR: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final document = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return UserModel.fromMap(document.data()!);
  }
}

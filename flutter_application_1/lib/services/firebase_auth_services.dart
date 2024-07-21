import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  Future<bool> signIn(String newEmail, String newPassword) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: newEmail, password: newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signUp(String newEmail, String newPassword) async {
    final _usersCollection = FirebaseFirestore.instance.collection('users');

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: newEmail, password: newPassword);
    var firebaseUser = FirebaseAuth.instance.currentUser;
    await _usersCollection
        .doc(firebaseUser!.uid)
        .set({'u_email': firebaseUser.email, 'uid': firebaseUser.uid});
  }

}

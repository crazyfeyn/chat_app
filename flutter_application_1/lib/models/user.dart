import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String uid;

  UserModel({required this.email, required this.uid});

  factory UserModel.fromQuery(QueryDocumentSnapshot query) {
    return UserModel(email: query['u_email'], uid: query['uid']);
  }
}

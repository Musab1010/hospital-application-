import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  String userName = "";
  String userRole = "";
  bool isActive = false;
  num balance = 1000;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user!.uid)
            .get(const GetOptions(source: Source.server));

        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          userName = userData['name'] ?? '';
          userRole = userData['role'] ?? 'pending';
          isActive = userData['isActive'] ?? false;
          balance = userData['balance'] ?? 1000;

          if (!isActive) {
            throw Exception("Account is not active.");
          }

          if (userRole == 'pending') {
            throw Exception("Account is pending activation.");
          }

          notifyListeners();
        }
      }
    } catch (e) {
      rethrow; // إعادة الخطأ إلى واجهة المستخدم
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    userName = "";
    userRole = "user";
    isActive = false;
    balance = 1000;
    notifyListeners();
  }
}

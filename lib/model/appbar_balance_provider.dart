// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BalanceProvider extends ChangeNotifier {
//   num _balance = 0;

//   num get balance => _balance;

//   // دالة لجلب الرصيد من Firestore
//   Future<void> fetchBalance(User user) async {
//     final docSnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     if (docSnapshot.exists) {
//       _balance = docSnapshot.data()?['balance'] ?? 0;
//     } else {
//       _balance = 0;
//     }
//     notifyListeners(); // إعلام الـ listeners بالتغيير
//   }
// }

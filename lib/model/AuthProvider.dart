import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegetoProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // دالة لتسجيل المستخدم
  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return "كلمات المرور غير متطابقة";
    }

    try {
      _isLoading = true;
      notifyListeners(); // إعلام المستمعين بوجود تغيير في الحالة

      // إنشاء حساب باستخدام Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // الحصول على uid
      String userId = userCredential.user!.uid;

      // إضافة بيانات المستخدم إلى Firestore
      await _firestore.collection('users').doc(userId).set({
        'uid': userId,
        'name': name,
        'email': email,
        'role': 'user', // الدور الافتراضي
        'hospitalId': name, // قيمة hospitalId فارغة عند التسجيل
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'balance': 1000, // رصيد افتراضي
      });

      _isLoading = false;
      notifyListeners(); // إعلام المستمعين بعد اكتمال التسجيل
      return null; // النجاح
    } catch (e) {
      _isLoading = false;
      notifyListeners(); // إعلام المستمعين في حالة حدوث خطأ
      return "حدث خطأ أثناء التسجيل: $e";
    }
  }

  // دالة لتفريغ الحقول
  void clearFields({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  }) {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}

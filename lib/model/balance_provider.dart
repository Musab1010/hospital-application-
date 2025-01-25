import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceProvider with ChangeNotifier {
  int currentBalance = 0;

  Future<void> fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        currentBalance = userDoc['balance'] ?? 0;
        notifyListeners();
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> createBalanceRequest(
    BuildContext context,
    int amount,
    int transactionId,
    String accountName,
    String accountNumber,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (transactionId.toString().length < 10) {
        _showSnackBar(context, 'رقم العملية خطأ');
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('transactionId', isEqualTo: transactionId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _showSnackBar(context, 'رقم المعاملة موجود بالفعل!');
        return;
      }

      await FirebaseFirestore.instance.collection('requests').add({
        'uid': user.uid,
        'amount': amount,
        'transactionId': transactionId,
        'accountName': accountName,
        'accountNumber': accountNumber,
        'isApproved': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSnackBar(context, 'تم إرسال طلب إضافة الرصيد');
      
      // تفريغ الحقول بعد الإرسال
      _resetForm(context);

    } catch (e) {
      _showSnackBar(context, 'حدث خطأ أثناء إرسال الطلب: $e');
    }
  }

  // تفريغ الحقول بعد الإرسال
  void _resetForm(BuildContext context) {
    // إفراغ الحقول بعد إرسال الطلب بنجاح
    currentBalance = 0;  // يمكنك إعادة تعيين الرصيد إلى قيمته الأصلية من الخادم
    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

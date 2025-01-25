import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsProvider with ChangeNotifier {
  List<String> hiddenRequests = [];
  bool isLoading = false;

  Future<void> approveRequest(String requestId, String userId, int amount) async {
    try {
      isLoading = true;
      notifyListeners();

      // تحديث حالة الطلب في Firestore
      await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
        'isApproved': true,
      });

      // تحديث الرصيد
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'balance': FieldValue.increment(amount),
      });

      // تحديث الطلبات محليًا
      hiddenRequests.add(requestId);
      notifyListeners();
    } catch (e) {
      throw Exception('حدث خطأ أثناء الموافقة: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      isLoading = true;
      notifyListeners();

      // حذف الطلب من Firestore
      await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();

      // تحديث الطلبات محليًا
      hiddenRequests.add(requestId);
      notifyListeners();
    } catch (e) {
      throw Exception('حدث خطأ أثناء الرفض: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

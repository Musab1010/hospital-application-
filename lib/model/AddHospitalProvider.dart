import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HospitalProvider with ChangeNotifier {
  String hospitalName = '';
  List<TextEditingController> departmentControllers = [];
  List<List<Map<String, TextEditingController>>> doctorControllers = [];

  // إضافة قسم جديد
  void addDepartment() {
    departmentControllers.add(TextEditingController());
    doctorControllers.add([]);
    notifyListeners();
  }

  // إضافة طبيب للقسم المحدد
  void addDoctor(int departmentIndex) {
    doctorControllers[departmentIndex].add({
      'name': TextEditingController(),
      'time': TextEditingController(),
    });
    notifyListeners();
  }

  // حفظ بيانات المستشفى
  void saveHospital(FirebaseFirestore firestore, BuildContext context) async {
    if (hospitalName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المستشفى')),
      );
      return;
    }

    try {
      final hospitalRef =
          await firestore.collection('hospitals').add({'name': hospitalName});

      for (int i = 0; i < departmentControllers.length; i++) {
        final departmentName = departmentControllers[i].text.trim();
        if (departmentName.isEmpty) continue;

        final departmentRef = await hospitalRef
            .collection('departments')
            .add({'name': departmentName});

        for (var doctor in doctorControllers[i]) {
          final doctorName = doctor['name']!.text.trim();
          final doctorTime = doctor['time']!.text.trim();
          if (doctorName.isEmpty || doctorTime.isEmpty) continue;

          final doctorRef = await departmentRef.collection('doctors').add({
            'name': doctorName,
          });

          await doctorRef.collection('doctor_times').add({
            'time': doctorTime,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المستشفى بنجاح')),
      );
      resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الإضافة: $e')),
      );
    }
  }

  // إعادة تعيين النموذج
  void resetForm() {
    hospitalName = '';
    departmentControllers.clear();
    doctorControllers.clear();
    notifyListeners();
  }

  // تعيين اسم المستشفى
  void setHospitalName(String name) {
    hospitalName = name;
    notifyListeners();
  }
}

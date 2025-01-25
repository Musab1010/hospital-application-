import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/BookingModel.dart';
import 'Darwer_user.dart';

class MyHomePage extends StatefulWidget {
  static const String screenRoute = "MyHomePage";

  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadHospitals();
  }

  Future<void> loadHospitals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore.collection('hospitals').get();
      if (mounted) {
        List<Map<String, String>> hospitalList = snapshot.docs.map((doc) {
          return {"name": doc['name'] as String, "id": doc.id};
        }).toList();

        context.read<BookingModel>().setHospitals(hospitalList);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("خطأ في تحميل المستشفيات: $e")));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadDepartments(String hospitalId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('hospitals')
          .doc(hospitalId)
          .collection('departments')
          .get();

      if (mounted) {
        List<Map<String, String>> departmentList = snapshot.docs.map((doc) {
          return {"name": doc['name'] as String, "id": doc.id};
        }).toList();

        context.read<BookingModel>().setDepartments(departmentList);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("خطأ في تحميل الأقسام: $e")));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadDoctors(String hospitalId, String departmentId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('hospitals')
          .doc(hospitalId)
          .collection('departments')
          .doc(departmentId)
          .collection('doctors')
          .get();

      if (mounted) {
        List<Map<String, String>> doctorList = snapshot.docs.map((doc) {
          return {"name": doc['name'] as String, "id": doc.id};
        }).toList();

        context.read<BookingModel>().setDoctors(doctorList);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("خطأ في تحميل الأطباء: $e")));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadDoctorTimes(
      String doctorId, String hospitalId, String departmentId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('hospitals')
          .doc(hospitalId)
          .collection('departments')
          .doc(departmentId)
          .collection('doctors')
          .doc(doctorId)
          .collection('doctor_times')
          .get();

      if (snapshot.docs.isNotEmpty && mounted) {
        List<String> times = snapshot.docs.map((doc) {
          return doc['time'] as String;
        }).toList();

        context.read<BookingModel>().setDoctorTimes(times);
      } else {
        context.read<BookingModel>().setDoctorTimes([]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("خطأ في تحميل أوقات الطبيب: $e")));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addBooking() async {
    final bookingModel = context.read<BookingModel>();

    if (_nameController.text.isEmpty ||
        bookingModel.selectedHospital == null ||
        bookingModel.selectedDepartment == null ||
        bookingModel.selectedDoctor == null ||
        bookingModel.doctorTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى ملء جميع الحقول")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('bookings').add({
        'name': _nameController.text,
        'hospital': bookingModel.selectedHospital,
        'department': bookingModel.selectedDepartment,
        'doctor': bookingModel.selectedDoctor,
        'time': bookingModel.doctorTime,
        'hospitalId': bookingModel.selectedHospital,
      });

      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        DocumentReference userRef = _firestore.collection('users').doc(uid);
        await userRef.update({
          'balance': FieldValue.increment(-200),
        });
      }

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تمت إضافة الحجز بنجاح")),
      );

      _nameController.clear();
      bookingModel.setSelectedHospital(null);
      bookingModel.setSelectedDepartment(null);
      bookingModel.setSelectedDoctor(null);
      bookingModel.setDoctorTime(null);
      bookingModel.setDoctorTimes([]);
      bookingModel.setDepartments([]);
      bookingModel.setDoctors([]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingModel = context.watch<BookingModel>();

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(_auth.currentUser?.uid).get(),
      builder: (context, snapshot) {
        String name = "جاري التحميل...";
        int balance = 0;

        if (snapshot.hasData && snapshot.data != null) {
          name = snapshot.data!['name'] ?? "غير معروف";
          balance = snapshot.data!['balance'] ?? 0;
        }

        return Scaffold(
         drawer: buildDrawerUser(context),
appBar: AppBar(
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 2, // تخصيص مساحة أكبر للاسم
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "مرحبا $name",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
            overflow: TextOverflow.ellipsis, // لإظهار النصوص الطويلة مع ...
          ),
        ),
      ),
      Expanded(
        flex: 1, // تخصيص مساحة ثابتة للرصيد
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "الرصيد: $balance",
            style: TextStyle(fontSize: 15.sp, color: Colors.white),
            textAlign: TextAlign.end, // لمحاذاة النص إلى اليمين
            overflow: TextOverflow.ellipsis, //  .ضمان النص لا يسبب مشاكل
          ),
        ),
      ),
    ],
  ),
  backgroundColor: Colors.blue,
),



          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:  EdgeInsets.all(16.0.h),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "الاسم رباعي",
                        labelText: "الاسم رباعي",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                    ),
                     SizedBox(height: 20.h),
                    DropdownButtonFormField<String?>(
                      value: bookingModel.selectedHospital,
                      decoration: InputDecoration(
                        labelText: "اختر المستشفى",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        filled: true,
                        fillColor: Colors.blue.shade50,
                      ),
                      items: bookingModel.hospitals
                          .map((Map<String, String> hospital) {
                        return DropdownMenuItem<String?>(
                          value: hospital['name'],
                          child: Text(hospital['name']!),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        bookingModel.setSelectedHospital(newValue);
                        if (newValue != null) {
                          final hospitalId = bookingModel.hospitals
                              .firstWhere((h) => h['name'] == newValue)['id']!;
                          loadDepartments(hospitalId);
                        }
                      },
                    ),
                     SizedBox(height: 20.h),
                    Visibility(
                      visible: bookingModel.selectedHospital != null,
                      child: DropdownButtonFormField<String?>(
                        value: bookingModel.selectedDepartment,
                        decoration: InputDecoration(
                          labelText: "اختر القسم",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                        items: bookingModel.departments
                            .map((Map<String, String> department) {
                          return DropdownMenuItem<String?>(
                            value: department['name'],
                            child: Text(department['name']!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          bookingModel.setSelectedDepartment(newValue);
                          if (newValue != null &&
                              bookingModel.selectedHospital != null) {
                            final hospitalId = bookingModel.hospitals
                                .firstWhere((h) =>
                                    h['name'] ==
                                    bookingModel.selectedHospital)['id']!;
                            final departmentId = bookingModel.departments
                                .firstWhere(
                                    (d) => d['name'] == newValue)['id']!;
                            loadDoctors(hospitalId, departmentId);
                          }
                        },
                      ),
                    ),
                     SizedBox(height: 20.h),
                    Visibility(
                      visible: bookingModel.selectedDepartment != null,
                      child: DropdownButtonFormField<String?>(
                        value: bookingModel.selectedDoctor,
                        decoration: InputDecoration(
                          labelText: "اختر الطبيب",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                        items: bookingModel.doctors
                            .map((Map<String, String> doctor) {
                          return DropdownMenuItem<String?>(
                            value: doctor['name'],
                            child: Text(doctor['name']!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          bookingModel.setSelectedDoctor(newValue);
                          if (newValue != null) {
                            final doctorId = bookingModel.doctors.firstWhere(
                                (d) => d['name'] == newValue)['id']!;
                            final hospitalId = bookingModel.hospitals
                                .firstWhere((h) =>
                                    h['name'] ==
                                    bookingModel.selectedHospital)['id']!;
                            final departmentId = bookingModel.departments
                                .firstWhere((d) =>
                                    d['name'] ==
                                    bookingModel.selectedDepartment)['id']!;
                            loadDoctorTimes(doctorId, hospitalId, departmentId);
                          }
                        },
                      ),
                    ),
                     SizedBox(height: 20.h),
                    Visibility(
                      visible: bookingModel.selectedDoctor != null,
                      child: DropdownButtonFormField<String?>(
                        value: bookingModel.doctorTime,
                        decoration: InputDecoration(
                          labelText: "اختر الوقت",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          filled: true,
                          fillColor: Colors.blue.shade50,
                        ),
                        items: bookingModel.doctorTimes.map((String time) {
                          return DropdownMenuItem<String?>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          bookingModel.setDoctorTime(newValue);
                        },
                      ),
                    ),
                     SizedBox(height: 25.h),
                    ElevatedButton(
                      onPressed: _isLoading ? null : addBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("إضافة الحجز"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DrawerAdmin.dart';

class BookingScreen extends StatelessWidget {
  static const String screenRoute = "BookingScreen";

  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // المستخدم الحالي
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      drawer: buildDrawerAdmin(context),
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: firestore.collection('users').doc(user!.uid).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Text('جاري التحميل...');
            }

            if (!userSnapshot.hasData ||
                userSnapshot.data == null ||
                !userSnapshot.data!.exists) {
              return const Text('مرحبًا');
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'غير معروف';

            return Row(
              children: [
                const Text(
                  'إدارة الحجوزات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Text(
                  'مرحبًا, $userName',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('users').doc(user.uid).get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData ||
              userSnapshot.data == null ||
              !userSnapshot.data!.exists) {
            return const Center(
              child: Text("لا يمكن العثور على بيانات المستخدم."),
            );
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

          // التحقق من دور المستخدم
          if (userData['role'] != 'admin') {
            return const Center(
              child: Text("هذه الصفحة مخصصة للإداريين فقط."),
            );
          }

          final hospitalId = userData['hospitalId'].toLowerCase().trim();
          print('Hospital ID from user (normalized): $hospitalId');

          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('bookings').snapshots(),
            builder: (context, bookingSnapshot) {
              if (bookingSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!bookingSnapshot.hasData ||
                  bookingSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("لا توجد حجوزات مرتبطة بهذا المستشفى."),
                );
              }

              // تصفية الحجوزات حسب hospitalId
              final filteredBookings = bookingSnapshot.data!.docs.where((doc) {
                final bookingData = doc.data() as Map<String, dynamic>;
                final bookingHospitalId =
                    (bookingData['hospitalId'] ?? '').toLowerCase().trim();
                return bookingHospitalId == hospitalId;
              }).toList();

              if (filteredBookings.isEmpty) {
                return const Center(
                  child: Text("لا توجد حجوزات مرتبطة بهذا المستشفى."),
                );
              }

              // ترتيب الحجوزات يدويًا حسب timestamp
              filteredBookings.sort((a, b) {
                final timestampA =
                    (a.data() as Map<String, dynamic>)['timestamp'] ??
                        Timestamp(0, 0);
                final timestampB =
                    (b.data() as Map<String, dynamic>)['timestamp'] ??
                        Timestamp(0, 0);
                return timestampB.compareTo(timestampA);
              });

              return ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  final bookingData =
                      filteredBookings[index].data() as Map<String, dynamic>;
                  final bookingId = filteredBookings[index].id;
                  bool isSeen = bookingData['seen'] ?? false;

                  return Card(
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0.w, horizontal: 2.0.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0.w),
                      leading: Icon(
                        Icons.assignment_turned_in,
                        color: Colors.blueAccent,
                        size: 30.sp,
                      ),
                      title: Text(
                        "اسم المريض: ${bookingData['name']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.local_hospital,
                                  color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  " ${bookingData['hospital']}",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              const Icon(Icons.category,
                                  color: Colors.orange),
                              SizedBox(width: 8.w),
                              Expanded(
                                  child: Text(
                                      "القسم: ${bookingData['department']}")),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.green),
                              SizedBox(width: 8.w),
                              Expanded(
                                  child: Text(
                                      "الطبيب: ${bookingData['doctor']}")),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.purple),
                              SizedBox(width: 8.w),
                              Expanded(
                                  child:
                                      Text("الوقت: ${bookingData['time']}")),
                            ],
                          ),
                          if (bookingData['timestamp'] != null)
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Text(
                                  "تاريخ الحجز: ${bookingData['timestamp'].toDate()}",
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSeen ? Colors.green : Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.h),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.w, horizontal: 20.h),
                        ),
                        onPressed: () {
                          // تحديث حالة "تمت الرؤية"
                          firestore
                              .collection('bookings')
                              .doc(bookingId)
                              .update({'seen': true});
                        },
                        child: Text(
                          isSeen ? "تمت الرؤية" : "تحديد كمقروء",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

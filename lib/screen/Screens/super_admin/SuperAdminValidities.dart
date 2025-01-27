import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model/updateuser.dart';

class Validities extends StatefulWidget {
  const Validities({super.key});

  @override
  State<Validities> createState() => _ValiditiesState();
}

class _ValiditiesState extends State<Validities> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // دالة للحصول على البيانات مع ترتيب تنازلي حسب تاريخ التسجيل (createdAt)
  Stream<QuerySnapshot> _getUserStream(String searchQuery) {
    final firestore = FirebaseFirestore.instance;

    if (searchQuery.isEmpty) {
      return firestore.collection('users').snapshots();
    } else {
      return firestore.collection('users')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
          .snapshots();
    }
  }

  // دالة لتحديث البيانات في Firestore
  Future<void> _updateUserData(String docId, String field, dynamic value) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(docId).update({field: value});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم تحديث البيانات بنجاح"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("حدث خطأ أثناء التحديث: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("لوحة المتميزين", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(16.0.h),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'بحث عن الاسم أو البريد الإلكتروني أو المستشفى',
                labelStyle: const TextStyle(color: Colors.teal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.w)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.teal),
                  onPressed: () {
                    // تحديث قيمة البحث باستخدام Provider
                    Provider.of<SearchProvider>(context, listen: false)
                        .updateSearchQuery(_searchController.text);
                  },
                ),
              ),
              onChanged: (value) {
                // تحديث قيمة البحث باستخدام Provider
                Provider.of<SearchProvider>(context, listen: false)
                    .updateSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                return StreamBuilder<QuerySnapshot>(
                  stream: _getUserStream(searchProvider.searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return  Center(
                        child: Text("لا توجد بيانات لعرضها.", style: TextStyle(fontSize: 18.sp, color: Colors.grey)),
                      );
                    }

                    final users = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final userData = users[index].data() as Map<String, dynamic>;
                        final bool isAdmin = userData['role'] == 'admin';

                        return Card(
                          margin:  EdgeInsets.symmetric(vertical: 8.0.w, horizontal: 16.0.h),
                          color: isAdmin ? Colors.teal.shade50 : Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(16.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: isAdmin ? Colors.teal : Colors.black,
                                      size: 24.sp,
                                    ),
                                     SizedBox(width: 8.h),
                                    Expanded( // اجعل الاسم قابلاً للتكبير ولكن داخل الحدود
                                      child: Text(
                                        "الاسم: ${userData['name'] ?? 'غير متوفر'}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          color: isAdmin ? Colors.teal : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis, // اختصار النص إذا تجاوز الحدود
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Colors.orange,
                                      size: 20.sp,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded( // اجعل البريد الإلكتروني قابل للتكبير
                                      child: Text(
                                        "البريد الإلكتروني: ${userData['email'] ?? 'غير متوفر'}",
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis, // اختصار النص
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      color: Colors.teal,
                                      size: 20.sp,
                                    ),
                                     SizedBox(width: 8.w),
                                    Expanded( // اجعل المستشفى قابل للتكبير
                                      child: Text(
                                        "المستشفى: ${userData['hospitalId'] ?? 'غير متوفر'}",
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis, // اختصار النص
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 8.h),
                                if (!isAdmin)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        color: Colors.blue,
                                        size: 20.sp,
                                      ),
                                       SizedBox(width: 8.w),
                                      Expanded(child: Text("UID: ${userData['uid'] ?? 'غير متوفر'}", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
                                    ],
                                  ),
                                if (isAdmin)
                                  Text(
                                    "role: ${userData['role'] ?? 'غير متوفر'}", 
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                 SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.green,
                                      size: 20.sp,
                                    ),
                                     SizedBox(width: 8.w),
                                    Expanded( // اجعل الرصيد قابلاً للتكبير
                                      child: Text(
                                        "الرصيد: ${userData['balance'] ?? 'غير متوفر'}",
                                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis, // اختصار النص
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // فتح مربع حوار لتعديل المستشفى
                                        _showEditDialog(userData['hospitalId'], users[index].id);
                                      },
                                      icon: const Icon(Icons.edit),
                                      label: const Text("تعديل المستشفى"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                      ),
                                    ),
                                     SizedBox(width: 8.w),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // تغيير قيمة الدور
                                        final newRole = isAdmin ? 'user' : 'admin';
                                        _updateUserData(users[index].id, 'role', newRole);
                                      },
                                      icon: const Icon(Icons.change_circle),
                                      label: Text(isAdmin ? "إلغاء دور المشرف" : "جعل مشرف"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // عرض مربع الحوار لتعديل المستشفى
  void _showEditDialog(String currentHospitalId, String docId) {
    TextEditingController hospitalController = TextEditingController(text: currentHospitalId);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("تعديل المستشفى"),
          content: TextField(
            controller: hospitalController,
            decoration: const InputDecoration(labelText: "المستشفى"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                _updateUserData(docId, 'hospitalId', hospitalController.text);
                Navigator.of(context).pop();
              },
              child: const Text("تحديث"),
            ),
          ],
        );
      },
    );
  }
}

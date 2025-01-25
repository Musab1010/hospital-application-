import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model/AddHospitalProvider.dart';

class AddHospitalPage extends StatefulWidget {
  static const String screenRoute = "AddHospitalPage";

  const AddHospitalPage({super.key});

  @override
  _AddHospitalPageState createState() => _AddHospitalPageState();
}

class _AddHospitalPageState extends State<AddHospitalPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مستشفى جديد'),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // استخدام Provider للحصول على اسم المستشفى
            Consumer<HospitalProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding:  EdgeInsets.only(bottom: 16.0.h),
                  child: TextField(
                    onChanged: (value) {
                      provider.setHospitalName(value); // تحديث اسم المستشفى
                    },
                    controller: TextEditingController(text: provider.hospitalName)..selection = TextSelection.fromPosition(TextPosition(offset: provider.hospitalName.length)), // التأكد من بقاء المؤشر في المكان الصحيح
                    decoration:  InputDecoration(
                      labelText: 'اسم المستشفى',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
                    ),
                  ),
                );
              },
            ),
             SizedBox(height: 10.h),

            // قسم الأقسام والأطباء
             Text(
              'الأقسام والأطباء:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
             SizedBox(height: 10.h),
            Consumer<HospitalProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.departmentControllers.length,
                  itemBuilder: (context, departmentIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // قسم الحقل
                        Padding(
                          padding:  EdgeInsets.only(bottom: 8.0.h),
                          child: TextField(
                            controller: provider.departmentControllers[departmentIndex],
                            decoration: InputDecoration(
                              labelText: 'اسم القسم ${departmentIndex + 1}',
                              border: const OutlineInputBorder(),
                              contentPadding:  EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
                            ),
                          ),
                        ),
                         SizedBox(height: 10.h),

                        // قسم الأطباء
                         Text(
                          'الأطباء:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                         SizedBox(height: 10.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.doctorControllers[departmentIndex].length,
                          itemBuilder: (context, doctorIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // حقل اسم الطبيب
                                Padding(
                                  padding:  EdgeInsets.only(bottom: 8.0.h),
                                  child: TextField(
                                    controller: provider.doctorControllers[departmentIndex][doctorIndex]['name'],
                                    decoration: InputDecoration(
                                      labelText: 'اسم الطبيب ${doctorIndex + 1}',
                                      border: const OutlineInputBorder(),
                                      contentPadding:  EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
                                    ),
                                  ),
                                ),
                                // حقل وقت الطبيب
                                Padding(
                                  padding:  EdgeInsets.only(bottom: 8.0.h),
                                  child: TextField(
                                    controller: provider.doctorControllers[departmentIndex][doctorIndex]['time'],
                                    decoration: InputDecoration(
                                      labelText: 'وقت الطبيب ${doctorIndex + 1}',
                                      border: const OutlineInputBorder(),
                                      contentPadding:  EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.h),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // زر إضافة طبيب
                        TextButton.icon(
                          onPressed: () => provider.addDoctor(departmentIndex),
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة طبيب'),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              },
            ),
            // زر إضافة قسم
            Consumer<HospitalProvider>(
              builder: (context, provider, child) {
                return TextButton.icon(
                  onPressed: provider.addDepartment,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة قسم'),
                );
              },
            ),
            const SizedBox(height: 20),

            // زر حفظ المستشفى
            Consumer<HospitalProvider>(
              builder: (context, provider, child) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.saveHospital(_firestore, context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:  EdgeInsets.symmetric(vertical: 12.0.w, horizontal: 20.0.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0.w),
                      ),
                    ),
                    child:  Text(
                      'حفظ المستشفى',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

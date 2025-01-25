import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model/SuperUserPanel.dart';
import 'drawer_super_admin.dart';

class SuperUserPanelScreen extends StatelessWidget {
      static const String screenRoute = "SuperUserPanelScreen";

  const SuperUserPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: buildDrawerSuperAdmin(context),
        appBar: AppBar(),
        body: ChangeNotifierProvider(
          create: (_) => SuperUserPanelProvider()..fetchData(),  // تفعيل الـ Provider
          child: Consumer<SuperUserPanelProvider>(
            builder: (context, provider, child) {
              return provider.collectionsLengths.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding:  EdgeInsets.all(16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'Dashboard',
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.bold),
                          ),
                           SizedBox(height: 16.h),
                          // إحصائيات المستخدمين
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDashboardCard(
                                title: 'Admins',
                                value: provider.usersCounts['admins']!,
                                icon: Icons.admin_panel_settings,
                                color: Colors.blue,
                              ),
                              _buildDashboardCard(
                                title: 'Users',
                                value: provider.usersCounts['users']!,
                                icon: Icons.people,
                                color: Colors.green,
                              ),
                            ],
                          ),
                           SizedBox(height: 24.h),
                           Text(
                            'Collections Statistics',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                           SizedBox(height: 16.h),
                          // إحصائيات المجموعات
                          ...provider.collectionsLengths.entries.map(
                            (entry) => Card(
                              elevation: 4,
                              margin:  EdgeInsets.symmetric(vertical: 8.w),
                              child: ListTile(
                                leading: Icon(
                                  _getIconForCollection(entry.key),
                                  color: _getColorForCollection(entry.key),
                                ),
                                title: Text(entry.key),
                                subtitle: Text('Documents: ${entry.value}'),
                              ),
                            ),
                          ),
                           SizedBox(height: 24.h),
                           Text(
                            'Bookings by Hospital',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                           SizedBox(height: 16.h),
                          // إحصائيات الحجوزات حسب المستشفى
                          ..._buildHospitalRows(provider.bookingsCounts),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  // نفس الدوال السابقة مثل _buildDashboardCard، _getIconForCollection، و _buildHospitalRows
}
  // Widget لإنشاء كرت يحتوي على الإحصائيات
  Widget _buildDashboardCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Container(
        width: 150.w,
        padding:  EdgeInsets.all(16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.sp,
              color: color,
            ),
             SizedBox(height: 8.h),
            Text(
              title,
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 8.h),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لاختيار الأيقونة بناءً على اسم المجموعة
  IconData _getIconForCollection(String collectionName) {
    switch (collectionName) {
      case 'users':
        return Icons.people;
      case 'hospitals':
        return Icons.local_hospital;
      case 'requests':
        return Icons.request_page;
      case 'bookings':
        return Icons.payment;
      default:
        return Icons.folder;
    }
  }

  // دالة لتعيين لون لكل مجموعة
  Color _getColorForCollection(String collectionName) {
    switch (collectionName) {
      case 'users':
        return Colors.green;
      case 'requests':
        return Colors.orange;
      case 'hospitals':
        return Colors.blue;
      case 'bookings':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // دالة لتقسيم بيانات المستشفيات إلى صفوف
  List<Widget> _buildHospitalRows(Map<String, int> bookingsCounts) {
    const int itemsPerRow = 3;  // عدد المستشفيات في كل صف
    List<Widget> rows = [];
    List<MapEntry<String, int>> entries = bookingsCounts.entries.toList();

    // تقسيم البيانات إلى صفوف من 3 مستشفيات
    for (int i = 0; i < entries.length; i += itemsPerRow) {
      int end = (i + itemsPerRow <= entries.length) ? i + itemsPerRow : entries.length;
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: entries.sublist(i, end).map((entry) {
            return _buildHospitalCard(entry.key, entry.value);
          }).toList(),
        ),
      );
      rows.add( SizedBox(height: 16.h));  // فصل بين الصفوف
    }

    return rows;
  }

  // Widget لإنشاء كرت يحتوي على معلومات المستشفى
  Widget _buildHospitalCard(String hospitalId, int bookingsCount) {
    return Card(
      elevation: 4,
      margin:  EdgeInsets.symmetric(vertical: 8.w),
      child: Container(
        width: 100,  // عرض الكرت
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital,
              color: Colors.blue,
            ),
             SizedBox(height: 8.h),
            Text(
              ' $hospitalId',
              style:  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 8.h),
            Text(
              'Bookings: $bookingsCount',
              style:  TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

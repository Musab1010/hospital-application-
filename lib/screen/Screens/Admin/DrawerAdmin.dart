import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildDrawerAdmin(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "القائمة الجانبية ",
              style: TextStyle(color: Colors.white, fontSize: 24.sp),
            ),
          ),
        
         
          ListTile(
            leading: Icon(Icons.logout, size: 22.sp),
            title: Text("تسجيل الخروج", style: TextStyle(fontSize: 15.sp)),
            onTap: () async {
              await FirebaseAuth.instance.signOut(); // تسجيل الخروج
              Navigator.pushReplacementNamed(context, 'LoginScreen'); // التوجه لشاشة تسجيل الدخول
            },
          ),
        ],
      ),
    );
  }

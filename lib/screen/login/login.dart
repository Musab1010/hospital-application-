import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Screens/Admin/AdminDashpord.dart';
import '../Screens/super_admin/SuperAdmin.dart';
import '../Screens/users/homeScrenn.dart';

class LoginScreen extends StatefulWidget {
  static const String screenRoute = "LoginScreen";

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passToggle = true;
  bool isLoading = false; // حالة التحميل
  User? user;

  Future<void> signInWithEmail() async {
    setState(() {
      isLoading = true; // بدء التحميل
    });

    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        showCustomDialog("خطأ", "يرجى ملء الحقول المطلوبة");
        setState(() {
          isLoading = false; // انتهاء التحميل
        });
        return;
      }

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      user = userCredential.user;

      if (user != null) {
        final snapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final userRole = userData['role'] ?? 'user';

          if (userRole == 'admin') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingScreen()));
          } else if (userRole == 'super_user') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuperUserPanelScreen()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          }
        }
      }
    } catch (e) {
      showCustomDialog("خطأ", "خطأ أثناء تسجيل الدخول: $e");
    } finally {
      setState(() {
        isLoading = false; // انتهاء التحميل
      });
    }
  }

  void showCustomDialog(String title, String message, {bool isError = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          backgroundColor: isError ? Colors.red[50] : Colors.green[50],
          title: Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? Colors.red : Colors.green, size: 24.sp),
              SizedBox(width: 8.w),
              Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: isError ? Colors.red : Colors.green)),
            ],
          ),
          content: Text(message, style: TextStyle(fontSize: 16.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("حسناً", style: TextStyle(color: isError ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 16.sp)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              // خلفية
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.r,
                            offset: Offset(0, 1.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // حقل البريد الإلكتروني
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "البريد الإلكتروني",
                              prefixIcon: Icon(Icons.email, color: Colors.black, size: 24.sp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 15.h),
                          // حقل كلمة المرور
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "كلمة المرور",
                              prefixIcon: Icon(Icons.lock, color: Colors.black, size: 24.sp),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    passToggle = !passToggle;
                                  });
                                },
                                child: Icon(
                                  passToggle ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.black,
                                  size: 24.sp,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            obscureText: passToggle,
                          ),
                          SizedBox(height: 20.h),
                          // زر تسجيل الدخول
                          ElevatedButton(
                            onPressed: isLoading ? null : signInWithEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 50.w),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                          SizedBox(height: 15.h),
                          // نصوص إضافية أسفل الزر
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pushNamed(context, 'RegistrationScreen');
                                },
                                child: Text(
                                  "انشاء حساب جديد",
                                  style: TextStyle(fontSize: 14.sp, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pushNamed(context, 'ResetPassword');
                                },
                                child: Text(
                                  "هل نسيت كلمة السر؟",
                                  style: TextStyle(fontSize: 14.sp, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../model/AuthProvider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _registerUser(BuildContext context) async {
    final authProvider = Provider.of<RegetoProvider>(context, listen: false);

    String? error = await authProvider.registerUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    if (error == null) {
      // تفريغ الحقول بعد نجاح العملية
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // توجيه المستخدم إلى الشاشة الرئيسية
      Navigator.pushNamed(context, 'LoginScreen');
    } else {
      // عرض رسالة الخطأ إذا كان هناك خطأ
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("خطأ"),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("موافق"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<RegetoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل حساب جديد", style: TextStyle(color: Colors.white),)),
      body: ScreenUtilInit(
        designSize: const Size(375, 812), // الحجم المرجعي للتصميم
        builder: (context, child) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w), // التباعد باستخدام ScreenUtil
              child: Card(
                elevation: 40.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r), // الزوايا باستخدام ScreenUtil
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          maxLength: 15,
                          decoration: InputDecoration(
                            labelText: "الاسم الكامل",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يرجى إدخال الاسم.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "البريد الإلكتروني",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يرجى إدخال البريد الإلكتروني.";
                            }
                            if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
                              return "يرجى إدخال بريد إلكتروني صحيح.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "كلمة المرور",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يرجى إدخال كلمة المرور.";
                            }
                            if (value.length < 6) {
                              return "يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: "تأكيد كلمة المرور",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "يرجى تأكيد كلمة المرور.";
                            }
                            if (value != _passwordController.text) {
                              return "كلمة المرور وتأكيدها غير متطابقين.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 32.h),
                        ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _registerUser(context);
                                  }
                                },
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "إنشاء الحساب",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15.h),
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, 'LoginScreen');
                              },
                              child: Text(
                                "هل لديك حساب؟   ",
                                style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }
}

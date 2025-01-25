import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomErrorScreen extends StatelessWidget {
    static const String screenRoute = "CustomErrorScreen";

  final String errorMessage;
  final VoidCallback onRetry;

  const CustomErrorScreen({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(16.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/error.json', // ضع ملف Lottie هنا
                width: 200.w,
                height: 200.h,
              ),
               SizedBox(height: 20.h),
              // Animated text with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 40.0.sp,
                  ),
                   SizedBox(width: 10.w),
                  AnimatedDefaultTextStyle(
                    duration:  Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent, // تغيير اللون هنا
                    ),
                    child: Text(
                      "Oops! Something went wrong",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
               SizedBox(height: 10.h),
              // Error message with animated text style
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic, // إضافة تنسيق مائل للنص
                  fontWeight: FontWeight.w500,
                ),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                ),
              ),
               SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:  EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 32.0.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0.w),
                  ),
                ),
                child: Text(
                  "Try Again",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

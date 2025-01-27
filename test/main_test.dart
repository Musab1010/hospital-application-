// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hospital/main.dart';
// import 'package:hospital/model/AuthProvider.dart';
// import 'package:hospital/model/Themedarkandlightmode.dart';
// import 'package:hospital/screen/onboarding/onboarding_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() {
//   // إعداد الاختبار
//   testWidgets('Test Main App', (WidgetTester tester) async {
//     // تأكد من تهيئة Firebase
//     await Firebase.initializeApp();

//     // بناء الـ Widget (تطبيقك الرئيسي) داخل MultiProvider
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => ThemeProvider()),
//           ChangeNotifierProvider(create: (_) => RegetoProvider()),
//           // أضف باقي الـ Providers هنا إذا لزم الأمر
//         ],
//         child: const MyApp(),
//       ),
//     );

//     // تحقق من وجود Widget من نوع MaterialApp
//     expect(find.byType(MaterialApp), findsOneWidget);

//     // تحقق من وجود شاشة OnboardingScreen في البداية
//     expect(find.byType(OnboardingScreen), findsOneWidget);

//     // تحقق من وجود النص "0" في أي مكان في التطبيق
//     expect(find.text("0"), findsOneWidget); // يمكن تعديل النص هنا حسب الحالة
//   });
// }
